defmodule Songmate.Workers.UpdateUserMusicPreferences do
  alias Songmate.Music
  alias Songmate.Accounts
  alias Songmate.MusicPreferences
  alias Songmate.TaskSupervisor

  @moduledoc """
  We update user's music preferences once per week because
  (1) This data is not easily changed.
  (2) This operation is costly.
  """
  @one_week_in_seconds 7 * 24 * 60 * 60

  def call(user, artists: artists, tracks: tracks, genres: genres) do
    if should_update(user) do
      Task.Supervisor.start_child(TaskSupervisor, fn ->
        artists
        |> Music.batch_get_or_create_artists(order: true)
        |> Enum.reject(&is_nil/1)
        |> MusicPreferences.batch_create_artist_preferences(user)

        tracks
        |> Music.batch_get_or_create_tracks(order: true)
        |> Enum.reject(&is_nil/1)
        |> MusicPreferences.batch_create_track_preferences(user)

        genres
        |> Music.batch_get_or_create_genres(order: true)
        |> Enum.reject(&is_nil/1)
        |> MusicPreferences.batch_create_genre_preferences(user)

        Accounts.update_user(user, %{preferences_updated_at: NaiveDateTime.local_now()})
      end)
    end
  end

  defp should_update(user) do
    !user.preferences_updated_at ||
      NaiveDateTime.diff(
        NaiveDateTime.local_now(),
        user.preferences_updated_at
      ) > @one_week_in_seconds
  end
end
