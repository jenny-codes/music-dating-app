defmodule Songmate.Community.MatchingServiceTest do
  use Songmate.DataCase, async: false
  alias Songmate.Community.MatchingService
  alias Songmate.Fixtures

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

  describe "find_top_match/1" do
    test "returns the user in db that matches input user the most" do
      start_supervised!({Fixtures.Accounts, %{}})
      user1 = user_fixture(valid_user_attrs())
      user2 = user_fixture(valid_2nd_user_attrs())
      Fixtures.Accounts.set_users([user1, user2])

      result = MatchingService.find_top_match(user1, FakeProfile)

      assert %{
               user: user2,
               score: 5,
               shared: %{tracks: [], artists: ["Coldplay"], genres: []}
             } == result
    end
  end

  describe "get_shared_preferences/2" do
    test "returns shared music types between two users" do
      result = MatchingService.get_shared_preferences(1, 2, FakeProfile)

      assert result == %{tracks: [], artists: ["Coldplay"], genres: []}
    end
  end
end
