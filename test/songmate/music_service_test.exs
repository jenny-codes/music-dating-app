defmodule Songmate.MusicServiceTest do
  use Songmate.DataCase, async: true
  alias Songmate.MusicService

  describe "batch_get_music_records/1" do
    test "get artist, track, genre records by id" do
      artist = artist_fixture()
      track = track_fixture()
      genre = genre_fixture()

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
