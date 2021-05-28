defmodule SongmateWeb.Router do
  use SongmateWeb, :router
  alias Songmate.Accounts

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:check_provider_token)
    plug(:put_current_user)
    plug(:put_user_token)
  end

  defp check_provider_token(conn, _params) do
    if Spotify.Authentication.tokens_present?(conn) do
      {:ok, conn} = Spotify.Authentication.refresh(conn)
      conn
    else
      redirect(conn, to: "/authorize")
    end
  end

  defp put_current_user(conn, _params) do
    user_attrs = SpotifyService.fetch_user_info(conn)
    current_user = conn.assigns[:current_user]
    # if current user and matches that from API, then do nothing
    # else if credential exists in DB, assign existing user to current user
    # else if new attributes, create record and assign to current user
    cond do
      current_user && current_user.credential.username == user_attrs[:username] ->
        conn

      user = Accounts.get_user_by_username(user_attrs[:username]) ->
        assign(conn, :current_user, user)

      true ->
        {:ok, user} =
          Accounts.create_user(%{
            name: user_attrs[:display_name],
            avatar: user_attrs[:avatar_url],
            credential: %{
              token: conn.cookies["spotify_access_token"],
              email: user_attrs[:email],
              username: user_attrs[:username],
              provider: :spotify
            }
          })

        assign(conn, :current_user, user)
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

    get("/", PageController, :index)
    get("/authorize", UserController, :authorize)
    get("/authenticate", UserController, :authenticate)
    get("/info", PageController, :info)
    get("/login", PageController, :login)
    get("/music", PageController, :music)
    get("/chat", PageController, :chat)
  end

  # Other scopes may use custom stacks.
  # scope "/api", SongmateWeb do
  #   pipe_through :api
  # end
end
