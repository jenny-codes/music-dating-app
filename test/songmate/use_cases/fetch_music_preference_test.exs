defmodule Songmate.FetchMusicPreferenceTest do
  use ExUnit.Case, async: true
  alias Songmate.UseCase.FetchMusicPreference

  test "returns a map with artist, track and genre" do
    %{
      artist: result_artists,
      track: result_tracks,
      genre: result_genres
    } = FetchMusicPreference.call(1)

    assert Enum.map(result_artists, & &1.id) == [1, 1, 1]
    assert Enum.map(result_tracks, & &1.id) == [1]
    assert Enum.map(result_genres, & &1.id) == [1]
  end
end
