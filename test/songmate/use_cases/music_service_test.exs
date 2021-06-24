defmodule Songmate.MusicServiceTest do
  use Songmate.DataCase, async: true
  alias Songmate.MusicService
  import Songmate.MusicFactory

  describe "batch_get_music_records/1" do
    test "get artist, track, genre records by id" do
      artist = create_artist()
      track = create_track()
      genre = create_genre()

      input = %{
        artist: [artist.id],
        track: [track.id],
        genre: [genre.id]
      }

      expected_result = %{
        artist: [artist],
        track: [track],
        genre: [genre]
      }

      result = MusicService.batch_get_music_records(input)

      assert expected_result == result
    end
  end
end
