defmodule SongmateWeb.Router do
  use SongmateWeb, :router
  alias Songmate.Accounts

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :check_provider_token
    plug :put_current_user
    plug :put_user_token
  end

  defp check_provider_token(conn, _params) do
    if Spotify.Authentication.tokens_present?(conn) do
      conn
    else
      redirect(conn, to: "/authorize")
    end
  end

  defp put_current_user(conn, _params) do
    user = case Accounts.get_user_by_token(conn.cookies["spotify_access_token"]) do
      nil ->
        {:ok, conn} = Spotify.Authentication.refresh(conn)
        user_attrs = SpotifyService.fetch_user_info(conn)

        case Accounts.get_user_by_username(user_attrs[:username]) do
          nil ->
            IO.puts("[DEBUG] new token: #{conn.cookies["spotify_access_token"]}}")
            {:ok, user} = Accounts.create_user(
              %{
                name: user_attrs[:display_name],
                avatar: user_attrs[:avatar_url],
                credential: %{
                  token: conn.cookies["spotify_access_token"],
                  email: user_attrs[:email],
                  username: user_attrs[:username],
                  provider: :spotify
                }
              }
            )
            user
          user ->
            IO.puts("[DEBUG] valid through username, token: #{user.credential.token}}")
            {:ok, _} = Accounts.update_credential(
              user.credential,
              %{token: conn.cookies["spotify_access_token"]}
            )
            user
        end
      user ->
        {:ok, conn} = Spotify.Authentication.refresh(conn)
        {:ok, _} = Accounts.update_credential(
          user.credential,
          %{token: conn.cookies["spotify_access_token"]}
        )
        IO.puts("[DEBUG] valid through token: #{user.credential.token}}")
        user
    end

    assign(conn, :current_user, user)
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
    plug :accepts, ["json"]
  end

  scope "/", SongmateWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/authorize", UserController, :authorize
    get "/authenticate", UserController, :authenticate
    get "/info", PageController, :info
    get "/login", PageController, :login
    get "/music", PageController, :music
    get "/chat", PageController, :chat
  end

  # Other scopes may use custom stacks.
  # scope "/api", SongmateWeb do
  #   pipe_through :api
  # end
end
