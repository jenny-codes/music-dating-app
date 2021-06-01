defmodule Songmate.Community.MatchingServiceTest do
  use Songmate.DataCase, async: true
  alias Songmate.MusicPreferences
  alias Songmate.Community.MatchingService

  describe "get_shared_preferences/2" do
    test "returns shared music types between two users" do
      user1 = user_fixture(valid_user_attrs())
      user2 = user_fixture(valid_2nd_user_attrs())
      shared = [track_fixture()]
      only_user1_liked = [artist_fixture()]
      only_user2_liked = [genre_fixture()]
      MusicPreferences.batch_create_track_preferences(shared, user1)
      MusicPreferences.batch_create_track_preferences(shared, user2)
      MusicPreferences.batch_create_artist_preferences(only_user1_liked, user1)
      MusicPreferences.batch_create_genre_preferences(only_user2_liked, user2)

      result = MatchingService.get_shared_preferences(user1, user2)

      assert result == %{tracks: shared, artists: [], genres: []}
    end
  end
end
