defmodule SongmateWeb.AuthPlugTest do
  use SongmateWeb.ConnCase, async: true
  import Mox
  alias Songmate.Mock
  alias SongmateWeb.AuthPlug

  setup :set_mox_from_context

  test "does nothing if current_user is present" do
    user = user_fixture()
    expect(Mock.AuthService, :fetch_user_with_token, 0, fn _ -> nil end)

    conn =
      build_conn()
      |> assign(:current_user, user)
      |> AuthPlug.call(%{})

    assert user.id == conn.assigns[:current_user].id
  end

  test "fetch user with token if no current user" do
    user = user_fixture()

    expect(Mock.AuthService, :fetch_user_with_token, fn conn -> {conn, user} end)

    conn =
      build_conn()
      |> init_test_session(%{})
      |> AuthPlug.call(%{})

    verify!()
    assert user.id == conn.assigns[:current_user].id
  end

  test "redirects to login if cannot find current_user" do
    expect(Mock.AuthService, :fetch_user_with_token, fn _conn -> nil end)

    conn =
      build_conn()
      |> init_test_session(%{})
      |> AuthPlug.call(%{})

    assert redirected_to(conn, 302) == "/authorize"
    verify!()
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        name: "Bass Wannabe",
        username: "hisongmate",
        credential: %{
          provider: :spotify,
          email: "hi@songmate.co",
          provider_uid: "hisongmate"
        }
      })
      |> Songmate.Accounts.UserService.create_user()

    user
  end
end
