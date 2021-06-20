defmodule Songmate.FindTopMatchTest do
  use ExUnit.Case, async: false
  alias Songmate.UseCase.FindTopMatch
  alias Songmate.Fixtures

  describe "call/1" do
    test "returns the user in db that matches input user the most" do
      start_supervised!({Fixtures.UserService, %{}})
      user1 = %{id: 1}
      user2 = %{id: 2}
      Fixtures.UserService.set_users([user1, user2])

      result = FindTopMatch.call(user1)

      assert %{
               user: user2,
               score: 5,
               shared: %{track: [], artist: [1], genre: []}
             } == result
    end
  end
end
