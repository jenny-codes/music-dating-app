defmodule SongmateWeb.Router do
  use SongmateWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:ensure_current_user)
    plug(:put_user_token)
  end

  pipeline :browser_public do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  defp ensure_current_user(conn, _params) do
    cond do
      conn.assigns[:current_user] ->
        conn

      get_session(conn, :current_user_id) ->
        user = Songmate.Repo.get!(Songmate.Accounts.User, get_session(conn, :current_user_id))
        assign(conn, :current_user, user)

      true ->
        conn
        |> Plug.Conn.put_session(:login_dest, conn.request_path)
        |> Phoenix.Controller.redirect(to: "/login")
        |> halt
    end
  end

  defp put_user_token(conn, _params) do
    if current_user = conn.assigns[:current_user] do
      token = Phoenix.Token.sign(conn, "user socket", current_user.id)
      assign(conn, :user_token, token)
    else
      conn
    end
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", SongmateWeb do
    pipe_through(:browser)

    get("/", UserController, :index)
    get("/chat", UserController, :chat)
  end

  scope "/", SongmateWeb do
    pipe_through(:browser_public)

    get("/login", AuthController, :login)
    get("/authorize", AuthController, :authorize)
    get("/authenticate", AuthController, :authenticate)
  end

  # Other scopes may use custom stacks.
  # scope "/api", SongmateWeb do
  #   pipe_through :api
  # end
end
