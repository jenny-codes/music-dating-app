defmodule Songmate.Worker.UpdateUserMusicPreferencesTest do
  use ExUnit.Case, async: false
  alias Songmate.Fixtures

  describe "call/1" do
    test "does not update if user has updated in the past week" do
      start_supervised!({Fixtures.Accounts, %{}})
      user = %{preferences_updated_at: NaiveDateTime.local_now()}

      Songmate.Workers.UpdateUserMusicPreferences.call(user, %{tracks: ["a track"]})

      refute Fixtures.Accounts.called_update_user(user)
    end
  end
end
