defmodule Songmate.UseCase.FindSharedPreference do
  alias Songmate.Accounts.MusicPreferenceService
  alias Songmate.Music.{Artist, Track, Genre}
  alias Songmate.MusicService

  @music_service Application.compile_env(:songmate, [:services, :music_service], MusicService)
  @music_pref_service Application.compile_env(
                        :songmate,
                        [:services, :music_preference_service],
                        MusicPreferenceService
                      )

  @spec call(any, any) :: %{artist: [Artist.t()], genre: [Genre.t()], track: [Track.t()]}
  def call(user1, user2) do
    joined_prefs =
      @music_pref_service.get_all_by_user([user1, user2])
      |> Enum.group_by(& &1.type, & &1.type_id)

    shared_artists =
      (joined_prefs[:artist] || []) |> select_duplicates() |> @music_service.get_artists()

    shared_tracks =
      (joined_prefs[:track] || []) |> select_duplicates() |> @music_service.get_tracks()

    shared_genres =
      (joined_prefs[:genre] || []) |> select_duplicates() |> @music_service.get_genres()

    %{
      artist: shared_artists,
      track: shared_tracks,
      genre: shared_genres
    }
  end

  defp select_duplicates(list) do
    list
    |> Enum.frequencies()
    |> Enum.filter(fn {_val, count} -> count > 1 end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.reject(&is_nil(&1))
  end
end