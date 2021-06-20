defmodule Songmate.ImportMusicPreferenceTest do
  use ExUnit.Case, async: false
  alias Songmate.Fixtures
  alias Songmate.UseCase.ImportMusicPreference

  describe "call/2" do
    test "will import user music record from Spotify" do
      start_supervised!({Fixtures.UserService, %{}})
      user = %{id: 3, preferences_updated_at: NaiveDateTime.local_now()}

      ImportMusicPreference.call(user, %{tracks: ["a track"]})

      assert Fixtures.UserService.called_update_user(user)
    end
  end
end
