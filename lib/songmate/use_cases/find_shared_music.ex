defmodule Songmate.UseCase.FindSharedMusic do
  alias Songmate.Accounts.MusicPreferenceService
  alias Songmate.MusicService
  alias Songmate.Music.{Artist, Track, Genre}

  @spec call(any, any) :: %{artist: [Artist.t()], genre: [Genre.t()], track: [Track.t()]}
  def call(user1, user2) do
    joined_prefs =
      MusicPreferenceService.get_all_by_user([user1, user2])
      |> Enum.group_by(& &1.type, & &1.type_id)

    shared_artists =
      (joined_prefs[:artist] || []) |> select_duplicates() |> MusicService.get_artists()

    shared_tracks =
      (joined_prefs[:track] || []) |> select_duplicates() |> MusicService.get_tracks()

    shared_genres =
      (joined_prefs[:genre] || []) |> select_duplicates() |> MusicService.get_genres()

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
