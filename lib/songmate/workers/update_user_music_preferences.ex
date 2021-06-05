defmodule Songmate.Workers.UpdateUserMusicPreferences do
  alias Songmate.Music
  alias Songmate.Accounts
  alias Songmate.TaskSupervisor

  @moduledoc """
  We update user's music preferences once per week because
  (1) This data is not easily changed.
  (2) This operation is costly.
  """
  @account_mod Application.compile_env(:songmate, [:context, :accounts], Accounts)
  @music_mod Application.compile_env(:songmate, [:context, :music], Music)

  @one_week_in_seconds 7 * 24 * 60 * 60

  @spec call(%Accounts.User{}, %{artists: [], tracks: [], genres: []}) :: any
  def call(user, %{} = music_profile) do
    if should_update(user) do
      default = %{artists: [], tracks: [], genres: []}
      music_profile = Enum.into(music_profile, default)

      Task.Supervisor.start_child(TaskSupervisor, fn ->
        artist_prefs =
          music_profile[:artists]
          |> @music_mod.batch_get_or_create_artists(order: true)
          |> build_music_prefs_for_user(user)

        track_prefs =
          music_profile[:tracks]
          |> @music_mod.batch_get_or_create_tracks(order: true)
          |> build_music_prefs_for_user(user)

        genre_prefs =
          music_profile[:genres]
          |> @music_mod.batch_get_or_create_genres(order: true)
          |> build_music_prefs_for_user(user)

        (artist_prefs ++ track_prefs ++ genre_prefs)
        |> @account_mod.batch_upsert_music_preferences_for_user(user.id)

        @account_mod.update_user(user, %{preferences_updated_at: NaiveDateTime.local_now()})
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

  defp build_music_prefs_for_user(attrs, user) do
    attrs
    |> Enum.reject(&is_nil/1)
    |> Enum.with_index(1)
    |> Enum.map(fn {attrs, rank} ->
      attrs
      |> Map.put(:rank, rank)
      |> Map.put(:user_id, user.id)
    end)
  end
end
