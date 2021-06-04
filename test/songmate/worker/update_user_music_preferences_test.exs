defmodule Songmate.Worker.UpdateUserMusicPreferencesTest do
  use Songmate.DataCase, async: false
  alias Songmate.Fixtures

  describe "call/1" do
    test "does not update if user has updated in the past week" do
      start_supervised!({Fixtures.Accounts, %{}})
      user = %{preferences_updated_at: NaiveDateTime.local_now()}
      track = track_fixture()

      Songmate.Workers.UpdateUserMusicPreferences.call(user, %{tracks: [track]})

      refute Fixtures.Accounts.called_update_user(user)
    end
  end
end
