defmodule SongmateWeb.AuthController do
  use SongmateWeb, :controller
  alias Songmate.AuthService

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
        login_dest = get_session(conn, :login_dest)

        conn
        |> put_session(:login_dest, nil)
        |> redirect(to: login_dest)

      {:error, conn} ->
        redirect(conn, to: "/error")
    end
  end
end
