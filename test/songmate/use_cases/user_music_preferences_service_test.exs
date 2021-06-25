defmodule Songmate.ImportMusicPreferenceTest do
  use Songmate.DataCase, async: true
  import Songmate.UserFactory
  alias Songmate.UseCase.ImportMusicPreference

  describe "call/2" do
    test "import user music record and update" do
      user = create_user(%{preferences_updated_at: nil})

      ImportMusicPreference.call(user, %{tracks: ["a track"]})

      assert user.preferences_updated_at
    end
  end
end
