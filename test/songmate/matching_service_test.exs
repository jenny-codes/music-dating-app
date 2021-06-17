defmodule Songmate.Community.MatchingServiceTest do
  use ExUnit.Case, async: false
  alias Songmate.Community.MatchingService
  alias Songmate.Fixtures

  describe "find_top_match/1" do
    test "returns the user in db that matches input user the most" do
      start_supervised!({Fixtures.Accounts, %{}})
      user1 = %{id: 1}
      user2 = %{id: 2}
      Fixtures.Accounts.set_users([user1, user2])

      result = MatchingService.find_top_match(user1)

      assert %{
               user: user2,
               score: 5,
               shared: %{track: [], artist: [1], genre: []}
             } == result
    end
  end

  describe "get_shared_preferences/2" do
    test "returns shared music types between two users" do
      result = MatchingService.get_shared_preferences(1, 2)

      assert result == %{track: [], artist: [1], genre: []}
    end
  end
end
