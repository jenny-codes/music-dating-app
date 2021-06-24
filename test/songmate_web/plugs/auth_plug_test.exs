defmodule SongmateWeb.AuthPlugTest do
  use SongmateWeb.ConnCase, async: true
  import Mox
  alias Songmate.Mock
  alias SongmateWeb.AuthPlug
  import Songmate.UserFactory

  test "does nothing if current_user is present" do
    user = create_user()
    expect(Mock.AuthService, :fetch_user_with_token, 0, fn _ -> nil end)

    conn =
      build_conn()
      |> assign(:current_user, user)
      |> AuthPlug.call(%{})

    verify!()
    assert user.id == conn.assigns[:current_user].id
  end

  test "fetch user with token if no current user" do
    user = create_user()

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
end
