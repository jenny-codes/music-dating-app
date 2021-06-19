defmodule SongmateWeb.Router do
  use SongmateWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(SongmateWeb.AuthPlug)
    plug(:put_user_token)
  end

  pipeline :browser_public do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
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

    get("/", UserController, :me)
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
