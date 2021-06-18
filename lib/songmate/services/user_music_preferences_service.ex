defmodule Songmate.Workers.UpdateUserMusicPreferences do
  alias Songmate.Music
  alias Songmate.TaskSupervisor
  alias Songmate.Accounts.User
  alias Songmate.Accounts.{UserRepo, MusicPreferenceRepo}

  @moduledoc """
  We update user's music preferences once per week because
  (1) This data is not easily changed.
  (2) This operation is costly.
  """
  @music_mod Application.compile_env(:songmate, [:context, :music], Music)
  @user_repo Application.compile_env(
               :songmate,
               [:adapters, :user_repo],
               UserRepo
             )
  @music_pref_repo Application.compile_env(
                     :songmate,
                     [:adapters, :music_preference_repo],
                     MusicPreferenceRepo
                   )

  @one_week_in_seconds 7 * 24 * 60 * 60

  @spec call(%User{}, %{artists: [], tracks: [], genres: []}) :: any
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
        |> @music_pref_repo.batch_upsert_music_preferences_for_user(user.id)

        @user_repo.update_user(user, %{preferences_updated_at: NaiveDateTime.local_now()})
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
