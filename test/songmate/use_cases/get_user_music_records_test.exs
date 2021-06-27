defmodule Songmate.GetUserMusicRecordsTest do
  use Songmate.DataCase, async: true
  alias Songmate.UseCase.GetUserMusicRecords
  import Songmate.UserFactory
  import Songmate.MusicFactory

  test "returns a map with artist, track and genre" do
    artist = create_artist()
    user = create_user_with_music_preference([artist])

    result = GetUserMusicRecords.call(user.id)

    assert result[:artist] == [artist]
    assert result[:track] == []
    assert result[:genre] == []
  end
end
