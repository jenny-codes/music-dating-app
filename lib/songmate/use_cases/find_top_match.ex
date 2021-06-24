defmodule Songmate.UseCase.FindTopMatch do
  alias Songmate.Accounts.User
  # alias Songmate.Music.{Artist, Track, Genre}
  alias Songmate.Accounts.UserService
  alias Songmate.Accounts.MusicPreferenceService

  @track_score 10
  @artist_score 5
  @genre_score 2

  alias Songmate.Music.{ArtistService, TrackService, GenreService}

  @spec call(integer()) :: %{
          shared: %{artist: any, genre: any, track: any},
          user: %User{}
        }
  def call(user_id) do
    shared_prefs =
      MusicPreferenceService.get_all_by_user([user_id])
      |> Enum.group_by(& &1.type, & &1.type_id)
      |> Enum.map(fn {type, type_ids} ->
        shared =
          MusicPreferenceService.get_all_by_type(type, type_ids)
          |> Enum.reject(&(&1.user_id == user_id))

        {type, shared}
      end)
      |> Map.new()

    shared_artist_prefs = shared_prefs[:artist] || []
    shared_track_prefs = shared_prefs[:track] || []
    shared_genre_prefs = shared_prefs[:genre] || []

    {user_with_highest_points, _points} =
      Map.new()
      |> add_match_points(:artist, Enum.map(shared_artist_prefs, & &1.user_id))
      |> add_match_points(:track, Enum.map(shared_track_prefs, & &1.user_id))
      |> add_match_points(:genre, Enum.map(shared_genre_prefs, & &1.user_id))
      |> Enum.max_by(fn {_user_id, points} -> points end)

    match_user = UserService.get_user(user_with_highest_points)

    shared_artists =
      shared_artist_prefs
      |> Enum.filter(&(&1.user_id == match_user.id))
      |> Enum.map(& &1.type_id)
      |> ArtistService.get_artists()

    shared_tracks =
      shared_track_prefs
      |> Enum.filter(&(&1.user_id == match_user.id))
      |> Enum.map(& &1.type_id)
      |> TrackService.get_tracks()

    shared_genres =
      shared_genre_prefs
      |> Enum.filter(&(&1.user_id == match_user.id))
      |> Enum.map(& &1.type_id)
      |> GenreService.get_genres()

    %{
      user: match_user,
      shared: %{artist: shared_artists, track: shared_tracks, genre: shared_genres}
    }
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
