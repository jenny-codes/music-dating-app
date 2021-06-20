defmodule Songmate.UserMusicPreferencesService do
  alias Songmate.Accounts.User
  alias Songmate.Accounts.{UserRepo, MusicPreferenceRepo}
  alias Songmate.Music.{ArtistRepo, TrackRepo, GenreRepo}
  alias Songmate.Importer.SpotifyService

  @moduledoc """
  We update user's music preferences once per week because
  (1) This data is not easily changed.
  (2) This operation is costly.
  """

  @artist_repo Application.compile_env(:songmate, [:adapters, :artist_repo], ArtistRepo)
  @track_repo Application.compile_env(:songmate, [:adapters, :track_repo], TrackRepo)
  @genre_repo Application.compile_env(:songmate, [:adapters, :genre_repo], GenreRepo)
  @user_repo Application.compile_env(:songmate, [:adapters, :user_repo], UserRepo)
  @music_pref_repo Application.compile_env(
                     :songmate,
                     [:adapters, :music_preference_repo],
                     MusicPreferenceRepo
                   )
  @importer_service Application.compile_env(
                      :songmate,
                      [:services, :import_spotify_service],
                      SpotifyService
                    )

  @spec import(%User{}, any) :: any
  def import(user, conn) do
    music_profile =
      conn
      |> @importer_service.listening_history()
      |> Enum.into(%{artists: [], tracks: [], genres: []})

    artist_prefs =
      music_profile[:artists]
      |> @artist_repo.batch_get_or_create_artists(order: true)
      |> build_music_prefs_for_user(user, :artist)

    track_prefs =
      music_profile[:tracks]
      |> @track_repo.batch_get_or_create_tracks(order: true)
      |> build_music_prefs_for_user(user, :track)

    genre_prefs =
      music_profile[:genres]
      |> @genre_repo.batch_get_or_create_genres(order: true)
      |> build_music_prefs_for_user(user, :genre)

    (artist_prefs ++ track_prefs ++ genre_prefs)
    |> @music_pref_repo.batch_upsert_music_preferences_for_user(user.id)

    @user_repo.update_user(user, %{preferences_updated_at: NaiveDateTime.local_now()})
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
