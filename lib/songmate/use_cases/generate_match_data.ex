defmodule Songmate.UseCase.GenerateMatchData do
  alias Songmate.Accounts.MusicPreferenceService
  alias Songmate.Music.{Artist, Track, Genre}

  @track_score 10
  @artist_score 5
  @genre_score 2

  @type music_type :: %{artist: [%Artist{}], track: [%Track{}], genre: [%Genre{}]}

  @music_pref_service Application.compile_env(
                        :songmate,
                        [:services, :music_preference_service],
                        MusicPreferenceService
                      )

  @spec call(integer(), integer()) :: %{
          score: integer(),
          shared: music_type()
        }
  def call(user_id1, user_id2) do
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
    @music_pref_service.get_all_by_user([user_id1, user_id2])
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
