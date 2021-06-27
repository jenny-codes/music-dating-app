defmodule Songmate.ImportMusicPreferenceTest do
  use Songmate.DataCase, async: true
  import Songmate.UserFactory
  alias Songmate.UseCase.ImportMusicPreference

  test "import music record and update user" do
    user = create_user(%{preferences_updated_at: nil})

    # For now we pass an empty map as conn
    ImportMusicPreference.call(user, %{})

    user =
      Songmate.Accounts.UserService.get_user(user.id) |> Songmate.Repo.preload(:music_preferences)

    assert user.preferences_updated_at
    assert Enum.count(user.music_preferences) == 3
  end

  test "store new music records into database" do
    user = create_user(%{preferences_updated_at: nil})

    # For now we pass an empty map as conn
    ImportMusicPreference.call(user, %{})

    assert Songmate.Repo.exists?(Songmate.Music.Artist)
    assert Songmate.Repo.exists?(Songmate.Music.Track)
    assert Songmate.Repo.exists?(Songmate.Music.Genre)
  end
end
