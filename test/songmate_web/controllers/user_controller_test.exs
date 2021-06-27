defmodule SongmateWeb.UserControllerTest do
  use SongmateWeb.ConnCase, async: true
  import Songmate.UserFactory
  import Songmate.MusicFactory

  describe "/" do
    test "shows the index page" do
      user = create_user()

      conn =
        build_conn()
        |> assign(:current_user, user)
        |> get("/")

      assert response(conn, 200)
    end
  end

  describe "/peek" do
    test "show shared music between current user and target user" do
      current_user = create_user()
      target_user = create_user()

      conn =
        build_conn()
        |> assign(:current_user, current_user)
        |> get("/peek", user: target_user.username)

      assert response(conn, 200)
    end

    test "redirects to homepage if :user param is not provided" do
      current_user = create_user()

      conn =
        build_conn()
        |> assign(:current_user, current_user)
        |> get("/peek")

      assert redirected_to(conn) =~ "/"
    end

    test "redirects to homepage if cannot find target user" do
      current_user = create_user()

      conn =
        build_conn()
        |> assign(:current_user, current_user)
        |> get("/peek", user: "non-existent-user")

      assert redirected_to(conn) =~ "/"
    end

    test "redirect to homepage if target user is current user" do
      current_user = create_user()

      conn =
        build_conn()
        |> assign(:current_user, current_user)
        |> get("/peek", user: current_user.username)

      assert redirected_to(conn) =~ "/"
    end
  end

  describe "/explore" do
    test "return the top match user for current user" do
      shared_music = [create_artist()]
      current_user = create_user_with_music_preference(shared_music)
      only_other_user = create_user_with_music_preference(shared_music)

      conn =
        build_conn()
        |> assign(:current_user, current_user)
        |> get("/explore")

      assert response(conn, 200)
      assert assert conn.resp_body =~ only_other_user.name
    end
  end
end
