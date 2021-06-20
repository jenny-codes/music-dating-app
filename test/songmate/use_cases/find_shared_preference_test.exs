defmodule Songmate.FindSharedPreferenceTest do
  use ExUnit.Case, async: true
  alias Songmate.UseCase.FindSharedPreference

  test "returns a map with artist, track and genre" do
    %{
      artist: result_artists,
      track: result_tracks,
      genre: result_genres
    } = FindSharedPreference.call(1, 2)

    assert Enum.map(result_artists, & &1.id) == [1]
    assert result_tracks == []
    assert result_genres == []
  end
end
