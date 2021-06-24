defmodule Songmate.FindTopMatchTest do
  use Songmate.DataCase, async: true
  alias Songmate.UseCase.FindTopMatch
  import Songmate.UserFactory
  import Songmate.MusicFactory

  describe "call/1" do
    test "returns the user in db that matches input user the most" do
      shared_artist = create_artist()
      not_shared_track = create_track()
      not_shared_genre = create_genre()

      user1 = create_user_with_music_preference([shared_artist, not_shared_track])
      user2 = create_user_with_music_preference([shared_artist])
      _user3 = create_user_with_music_preference([not_shared_genre])

      result = FindTopMatch.call(user1.id)

      assert %{
               user: user2,
               shared: %{track: [], artist: [shared_artist], genre: []}
             } == result
    end
  end
end
