defmodule Songmate.MatchingService do
  alias Songmate.Accounts.User
  alias Songmate.Accounts.{UserRepo, MusicPreferenceRepo}
  alias Songmate.Music.{Artist, Track, Genre}

  @track_score 10
  @artist_score 5
  @genre_score 2

  @type music_type :: %{artist: [%Artist{}], track: [%Track{}], genre: [%Genre{}]}

  @music_pref_repo Application.compile_env(
                     :songmate,
                     [:adapters, :music_preference_repo],
                     MusicPreferenceRepo
                   )
  @user_repo Application.compile_env(
               :songmate,
               [:adapters, :user_repo],
               UserRepo
             )

  @spec find_top_match(%User{}) :: %{user: %User{}, score: integer(), shared: music_type()}
  def find_top_match(user) do
    candidates = @user_repo.list_users(except: [user.id])

    candidates
    |> Enum.map(& &1.id)
    |> Enum.map(&generate_match_data(user.id, &1))
    |> Enum.zip(candidates)
    |> Enum.map(fn {data, user} -> Map.put(data, :user, user) end)
    |> Enum.max_by(&Map.get(&1, :score))
  end

  @spec generate_match_data(integer(), integer()) :: %{
          score: integer(),
          shared: music_type()
        }
  def generate_match_data(user_id1, user_id2) do
    shared = get_shared_preferences(user_id1, user_id2)

    artist_scores = Enum.count(shared[:artist]) * @artist_score
    track_scores = Enum.count(shared[:track]) * @track_score
    genre_scores = Enum.count(shared[:genre]) * @genre_score

    %{
      shared: shared,
      score: track_scores + artist_scores + genre_scores
    }
  end

  @spec get_shared_preferences(integer(), integer()) :: music_type()
  def get_shared_preferences(user_id1, user_id2) do
    @music_pref_repo.list_music_preferences(user_ids: [user_id1, user_id2])
    |> Enum.group_by(& &1.type, & &1.type_id)
    |> Enum.map(fn {type, type_ids} -> {type, select_duplicates(type_ids)} end)
    |> Map.new()
  end

  defp select_duplicates(list) do
    list
    |> Enum.frequencies()
    |> Enum.filter(fn {_val, count} -> count > 1 end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.reject(&is_nil(&1))
  end
end
