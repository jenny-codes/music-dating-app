defmodule Songmate.UseCase.FindTopMatch do
  alias Songmate.Accounts.User
  alias Songmate.Accounts.UserService
  alias Songmate.Accounts.MusicPreferenceService
  alias Songmate.MusicService

  @track_score 10
  @artist_score 5
  @genre_score 2

  @spec call(integer()) :: %{
          shared: %{artist: any, genre: any, track: any},
          user: %User{}
        }
  def call(user_id) do
    user_music_prefs = MusicPreferenceService.get_all_by_user([user_id])

    shared =
      Enum.map(user_music_prefs, fn {type, type_ids} ->
        shared =
          MusicPreferenceService.get_all_by_type(type, type_ids)
          |> Enum.reject(&(&1.user_id == user_id))

        {type, shared}
      end)
      |> Enum.into(%{artist: [], track: [], genre: []})

    {user_with_highest_points, _points} =
      shared
      |> Enum.reduce(%{}, fn {type, prefs}, acc ->
        add_match_points(acc, type, Enum.map(prefs, & &1.user_id))
      end)
      |> Enum.max_by(fn {_user_id, points} -> points end)

    match_user = UserService.get_user(user_with_highest_points)

    %{
      user: match_user,
      shared: %{
        artist: get_shared_music(:artist, shared, match_user.id),
        track: get_shared_music(:track, shared, match_user.id),
        genre: get_shared_music(:genre, shared, match_user.id)
      }
    }
  end

  defp get_shared_music(type, list, match_user_id) do
    list
    |> Map.get(type)
    |> Enum.filter(&(&1.user_id == match_user_id))
    |> Enum.map(& &1.type_id)
    |> then(&MusicService.get(:artist, &1))
  end

  defp add_match_points(record, type, user_ids) do
    point =
      case type do
        :artist -> @artist_score
        :track -> @track_score
        :genre -> @genre_score
      end

    Enum.reduce(user_ids, record, fn user_id, acc ->
      new_point = Map.get(acc, user_id, 0) + point
      Map.put(acc, user_id, new_point)
    end)
  end
end
