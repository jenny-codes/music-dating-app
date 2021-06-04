defmodule Songmate.Community.MatchingService do
  alias Songmate.Accounts
  alias Songmate.Accounts.User
  alias Songmate.MusicPreferences

  @track_score 10
  @artist_score 5
  @genre_score 2

  @type music_type :: %{
          artists: [%Songmate.Music.Artist{}],
          tracks: [%Songmate.Music.Track{}],
          genres: [%Songmate.Music.Genre{}]
        }

  @account_mod Application.compile_env(:songmate, [:context, :accounts], Accounts)

  @spec find_top_match(%User{}, any()) :: %{user: %User{}, score: integer(), shared: music_type()}
  def find_top_match(user, profile_mod \\ MusicPreferences) do
    candidates = @account_mod.list_users(except: [user.id])

    candidates
    |> Enum.map(& &1.id)
    |> Enum.map(&generate_match_data(user.id, &1, profile_mod))
    |> Enum.zip(candidates)
    |> Enum.map(fn {data, user} -> Map.put(data, :user, user) end)
    |> Enum.max_by(&Map.get(&1, :score))
  end

  @spec generate_match_data(integer(), integer(), any()) :: %{
          score: integer(),
          shared: music_type()
        }
  def generate_match_data(user_id1, user_id2, profile_mod \\ MusicPreferences) do
    shared = get_shared_preferences(user_id1, user_id2, profile_mod)

    artist_scores = Enum.count(shared[:artists]) * @artist_score
    track_scores = Enum.count(shared[:tracks]) * @track_score
    genre_scores = Enum.count(shared[:genres]) * @genre_score

    %{
      shared: shared,
      score: track_scores + artist_scores + genre_scores
    }
  end

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
