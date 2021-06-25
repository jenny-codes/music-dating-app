defmodule Songmate.GenerateMatchDataTest do
  use Songmate.DataCase, async: true
  alias Songmate.UseCase.GenerateMatchData

  describe "get_shared_preferences/2" do
    test "returns shared music types between two users" do
      result = GenerateMatchData.get_shared_preferences(1, 2)

      assert result == %{track: [], artist: [1], genre: []}
    end
  end
end
