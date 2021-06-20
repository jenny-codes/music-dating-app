defmodule Songmate.UseCase.ImportMusicPreference do
  alias Songmate.Accounts.User
  alias Songmate.Accounts.{UserService, MusicPreferenceService}
  alias Songmate.Music.{ArtistService, TrackService, GenreService}
  alias Songmate.Importer.SpotifyService

  @moduledoc """
  We update user's music preferences once per week because
  (1) This data is not easily changed.
  (2) This operation is costly.
  """

  @callback call(%User{}, any) :: any

  @artist_service Application.compile_env(:songmate, [:services, :artist_service], ArtistService)
  @track_service Application.compile_env(:songmate, [:services, :track_service], TrackService)
  @genre_service Application.compile_env(:songmate, [:services, :genre_service], GenreService)
  @user_service Application.compile_env(:songmate, [:services, :user_service], UserService)
  @music_pref_service Application.compile_env(
                        :songmate,
                        [:services, :music_preference_service],
                        MusicPreferenceService
                      )
  @importer_service Application.compile_env(
                      :songmate,
                      [:services, :spotify_service],
                      SpotifyService
                    )

  @spec call(%User{}, any) :: any
  def call(user, conn) do
    music_profile =
      conn
      |> @importer_service.listening_history()
      |> Enum.into(%{artists: [], tracks: [], genres: []})

    artist_prefs =
      music_profile[:artists]
      |> @artist_service.batch_get_or_create_artists(order: true)
      |> build_music_prefs_for_user(user, :artist)

    track_prefs =
      music_profile[:tracks]
      |> @track_service.batch_get_or_create_tracks(order: true)
      |> build_music_prefs_for_user(user, :track)

    genre_prefs =
      music_profile[:genres]
      |> @genre_service.batch_get_or_create_genres(order: true)
      |> build_music_prefs_for_user(user, :genre)

    (artist_prefs ++ track_prefs ++ genre_prefs)
    |> @music_pref_service.batch_upsert_music_preferences_for_user(user.id)

    @user_service.update_user(user, %{preferences_updated_at: NaiveDateTime.local_now()})
  end

  defp build_music_prefs_for_user(attrs, user, type) do
    attrs
    |> Enum.reject(&is_nil/1)
    |> Enum.with_index(1)
    |> Enum.map(fn {attrs, rank} ->
      %{
        type: type,
        type_id: attrs.id,
        user_id: user.id,
        rank: rank
      }
    end)
  end
end
