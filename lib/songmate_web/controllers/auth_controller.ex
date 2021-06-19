defmodule SongmateWeb.AuthController do
  use SongmateWeb, :controller
  alias Songmate.AuthService

  def login(conn, _param) do
    login_with_token(conn) || redirect(conn, to: "/authorize")
  end

  defp login_with_token(conn) do
    case AuthService.validate_and_refresh_token(conn) do
      {:ok, conn} ->
        login_dest = get_session(conn, :login_dest)
        {:ok, user} = AuthService.fetch_user(conn)

        conn
        |> put_session(:login_dest, nil)
        |> put_session(:current_user_id, user.id)
        |> redirect(to: login_dest)

      _ ->
        nil
    end
  end

  @doc """
  Authorize is the step that asks user to sign in.
  After a user successfully sign in, Spotify will redirect to /authenticate, where we
  then requst access and refresh tokens. After that, we can use the access token to
  make Web API request to Spotify.

  Ref: https://developer.spotify.com/documentation/general/guides/authorization-guide/#authorization-code-flow
  """
  def authorize(conn, _params) do
    redirect(conn, external: AuthService.authorize_url())
  end

  def authenticate(conn, params) do
    case AuthService.authenticate(conn, params) do
      {:ok, conn} ->
        redirect(conn, to: "/")

      {:error, conn} ->
        redirect(conn, to: "/error")
    end
  end
end
