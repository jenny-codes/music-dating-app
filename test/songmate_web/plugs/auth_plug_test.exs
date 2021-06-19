defmodule SongmateWeb.AuthPlugTest do
  use SongmateWeb.ConnCase, async: true
  # use Plug.Test
  alias SongmateWeb.AuthPlug

  test "does nothing if current_user is present" do
    user = user_fixture()

    conn =
      build_conn()
      |> get("/")
      |> assign(:current_user, user)
      |> AuthPlug.call(%{})

    assert user.id == conn.assigns[:current_user].id
  end

  test "looks up current_user of id is present" do
    user = user_fixture()

    conn =
      build_conn()
      |> init_test_session(%{current_user_id: user.id})
      |> AuthPlug.call(%{})

    assert user.id == conn.assigns[:current_user].id
  end

  test "redirects to login if cannot find current_user by id" do
    conn =
      build_conn()
      |> init_test_session(%{current_user_id: 0})
      |> AuthPlug.call(%{})

    assert redirected_to(conn, 302) == "/login"
  end

  test "redirects to login if cannot find current user" do
    conn =
      build_conn()
      |> init_test_session(%{})
      |> AuthPlug.call(%{})

    assert redirected_to(conn, 302) == "/login"
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
      |> Songmate.Accounts.UserRepo.create_user()

    user
  end
end
