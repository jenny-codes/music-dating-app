defmodule Songmate.GenerateMatchDataTest do
  use Songmate.DataCase, async: true
  alias Songmate.UseCase.GenerateMatchData
  import Songmate.UserFactory
  import Songmate.MusicFactory

  describe "get_shared_preferences/2" do
    test "returns shared music types between two users" do
      shared_artist = create_artist()
      not_shared_track = create_track()
      user1 = create_user_with_music_preference([shared_artist, not_shared_track])
      user2 = create_user_with_music_preference([shared_artist])

      result = GenerateMatchData.get_shared_preferences(user1.id, user2.id)

      assert result == %{track: [], artist: [shared_artist.id], genre: []}
    end
  end
end
