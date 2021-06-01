defmodule Songmate.Community.MatchingServiceTest do
  use Songmate.DataCase, async: true
  alias Songmate.Community.MatchingService

  defmodule FakePreference do
    defstruct [:user_id, :artist, :track, :genre]
  end

  defmodule FakeProfile do
    def list_preferences(_, _) do
      [
        %FakePreference{artist: "Coldplay"},
        %FakePreference{artist: "Coldplay"},
        %FakePreference{artist: "Coldplay"},
        %FakePreference{track: "Yellow"},
        %FakePreference{genre: "coolkid pop"}
      ]
    end
  end

  describe "generate_match_data/2" do
    test "returns the match data between two users" do
      result = MatchingService.generate_match_data(1, 2, FakeProfile)

      assert result == %{
               shared: %{tracks: [], artists: ["Coldplay"], genres: []},
               score: 5
             }
    end
  end

  describe "get_shared_preferences/2" do
    test "returns shared music types between two users" do
      result = MatchingService.get_shared_preferences(1, 2, FakeProfile)

      assert result == %{tracks: [], artists: ["Coldplay"], genres: []}
    end
  end
end
