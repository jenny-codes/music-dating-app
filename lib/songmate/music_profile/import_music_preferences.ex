defmodule Songmate.UseCase.ImportMusicPreference do
  alias Songmate.Accounts.User
  alias Songmate.Accounts.{UserService, MusicPreferenceService}
  alias Songmate.MusicService
  alias Songmate.Importer.SpotifyService

  @moduledoc """
  We update user's music preferences once per week because
  (1) This data is not easily changed.
  (2) This operation is costly.
  """

  @callback call(%User{}, any) :: any
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
      |> MusicService.batch_create_artists(order: true)
      |> build_music_prefs_for_user(user, :artist)

    track_prefs =
      music_profile[:tracks]
      |> MusicService.batch_create_tracks(order: true)
      |> build_music_prefs_for_user(user, :track)

    genre_prefs =
      music_profile[:genres]
      |> MusicService.batch_create_genres(order: true)
      |> build_music_prefs_for_user(user, :genre)

    (artist_prefs ++ track_prefs ++ genre_prefs)
    |> MusicPreferenceService.batch_upsert_for_user(user.id)

    UserService.update_user(user, %{preferences_updated_at: NaiveDateTime.local_now()})
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
