defmodule Songmate.Community.MatchingService do
  alias Songmate.Accounts
  alias Songmate.Accounts.User
  alias Songmate.MusicPreferences

  @type music_type :: %{
          artists: [%Songmate.Music.Artist{}],
          tracks: [%Songmate.Music.Track{}],
          genres: [%Songmate.Music.Genre{}]
        }

  @spec get_shared_preferences(%User{}, %User{}) :: music_type()
  def get_shared_preferences(user1, user2) do
    calculate = fn type ->
      shared_list =
        type
        |> MusicPreferences.list_preferences(user_ids: [user1.id, user2.id])
        |> Enum.map(&Map.get(&1, type))

      (shared_list -- Enum.uniq(shared_list)) |> Enum.uniq()
    end

    %{
      artists: calculate.(:artist),
      tracks: calculate.(:track),
      genres: calculate.(:genre)
    }
  end
end
