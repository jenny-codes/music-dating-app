defmodule Songmate.FindSharedMusicTest do
  use Songmate.DataCase, async: true
  alias Songmate.UseCase.FindSharedMusic
  import Songmate.UserFactory
  import Songmate.MusicFactory

  test "returns music records that both user like" do
    shared_artist = create_artist()
    not_shared_track = create_track()
    user1 = create_user_with_music_preference([shared_artist, not_shared_track])
    user2 = create_user_with_music_preference([shared_artist])

    result = FindSharedMusic.call(user1.id, user2.id)

    assert result[:artist] == [shared_artist]
    assert result[:track] == []
    assert result[:genre] == []
  end
end
