defmodule Songmate.Worker.UpdateUserMusicPreferencesTest do
  use Songmate.DataCase, async: true

  describe "call/1" do
    test "does not update if user has updated in the past week" do
      user = user_fixture(%{preferences_updated_at: NaiveDateTime.local_now()})
      track = track_fixture()

      Songmate.Workers.UpdateUserMusicPreferences.call(user, %{tracks: [track]})

      refute Songmate.Repo.exists?(Songmate.MusicPreferences.TrackPreference)
    end
  end
end
