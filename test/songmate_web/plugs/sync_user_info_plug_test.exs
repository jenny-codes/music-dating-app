defmodule SongmateWeb.SyncUserInfoPlugTest do
  use SongmateWeb.ConnCase, async: true
  import Mox
  alias Songmate.Mock
  alias SongmateWeb.SyncUserInfoPlug
  import Songmate.UserFactory

  setup :set_mox_from_context

  test "does nothing if last update was less than 1 week ago" do
    just_now = NaiveDateTime.local_now()
    user = create_user(%{preferences_updated_at: just_now})
    expect(Mock.ImportMusicPreference, :call, 0, fn ^user, _ -> nil end)

    build_conn()
    |> assign(:current_user, user)
    |> SyncUserInfoPlug.call(%{})

    verify!()
    assert user.preferences_updated_at == just_now
  end

  test "import and update user data if is new user" do
    user = create_user(%{preferences_updated_at: nil})
    expect(Mock.ImportMusicPreference, :call, 1, fn ^user, _ -> nil end)

    build_conn()
    |> assign(:current_user, user)
    |> SyncUserInfoPlug.call(%{})

    verify!()
  end

  test "import and update user data if last updated was over 1 week ago" do
    two_weeks_ago = NaiveDateTime.local_now() |> NaiveDateTime.add(-2 * 7 * 24 * 60 * 60)
    user = create_user(%{preferences_updated_at: two_weeks_ago})
    expect(Mock.ImportMusicPreference, :call, 1, fn ^user, _ -> nil end)

    build_conn()
    |> assign(:current_user, user)
    |> SyncUserInfoPlug.call(%{})

    verify!()
  end
end
