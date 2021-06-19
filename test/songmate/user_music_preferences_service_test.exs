defmodule Songmate.UserMusicPreferencesServiceTest do
  use ExUnit.Case, async: false
  alias Songmate.Fixtures

  describe "import/2" do
    test "will import user music record from Spotify" do
      start_supervised!({Fixtures.UserRepo, %{}})
      user = %{id: 3, preferences_updated_at: NaiveDateTime.local_now()}

      Songmate.UserMusicPreferencesService.import(user, %{tracks: ["a track"]})

      assert Fixtures.UserRepo.called_update_user(user)
    end
  end
end
