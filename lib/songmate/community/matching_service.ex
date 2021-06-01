defmodule Songmate.Community.MatchingService do
  alias Songmate.Accounts
  alias Songmate.Accounts.User
  alias Songmate.MusicPreferences

  @type music_type :: %{
          artists: [%Songmate.Music.Artist{}],
          tracks: [%Songmate.Music.Track{}],
          genres: [%Songmate.Music.Genre{}]
        }

  @spec get_shared_preferences(integer(), integer(), any) :: music_type()
  def get_shared_preferences(user_id1, user_id2, profile_mod \\ MusicPreferences) do
    calculate = fn type ->
      shared_list =
        type
        |> profile_mod.list_preferences(user_ids: [user_id1, user_id2])
        |> Enum.map(&Map.get(&1, type))

      (shared_list -- Enum.uniq(shared_list))
      |> Enum.uniq()
      |> Enum.reject(&is_nil(&1))
    end

    %{
      artists: calculate.(:artist),
      tracks: calculate.(:track),
      genres: calculate.(:genre)
    }
  end
end
