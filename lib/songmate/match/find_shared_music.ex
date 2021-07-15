defmodule Songmate.UseCase.FindSharedMusic do
  alias Songmate.Accounts.MusicPreferenceService
  alias Songmate.MusicService
  alias Songmate.Music.{Artist, Track, Genre}

  @spec call(any, any) :: %{artist: [Artist.t()], genre: [Genre.t()], track: [Track.t()]}
  def call(user1, user2) do
    joined_prefs = MusicPreferenceService.get_all_by_user([user1, user2])

    %{
      artist: select_shared(:artist, joined_prefs),
      track: select_shared(:track, joined_prefs),
      genre: select_shared(:genre, joined_prefs)
    }
  end

  defp select_shared(type, prefs) do
    (prefs[type] || [])
    |> select_duplicates()
    |> then(&MusicService.get(type, &1))
  end

  defp select_duplicates(list) do
    list
    |> Enum.frequencies()
    |> Enum.filter(fn {_val, count} -> count > 1 end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.reject(&is_nil(&1))
  end
end
