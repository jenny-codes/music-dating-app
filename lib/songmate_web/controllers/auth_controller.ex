defmodule SongmateWeb.AuthController do
  use SongmateWeb, :controller
  alias Songmate.Accounts
  alias Songmate.SpotifyService

  def login(conn, _param) do
    login_with_token(conn) || redirect(conn, to: "/authorize")
  end

  defp login_with_token(conn) do
    with {:ok, conn} <- SpotifyService.validate_and_refresh_token(conn),
         info <- SpotifyService.fetch_user_info(conn),
         normalized <- normalize_to_user_attrs(info),
         {:ok, user} <-
           Accounts.get_or_create_user([username: normalized.credential.username], normalized) do
      login_dest = get_session(conn, :login_dest)

      conn
      |> put_session(:login_dest, nil)
      |> put_session(:current_user_id, user.id)
      |> redirect(to: login_dest)
    else
      _ -> nil
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
    redirect(conn, external: Spotify.Authorization.url())
  end

  def authenticate(conn, params) do
    case Spotify.Authentication.authenticate(conn, params) do
      {:ok, conn} ->
        redirect(conn, to: "/")

      {:error, conn} ->
        redirect(conn, to: "/error")
    end
  end

  defp normalize_to_user_attrs(user_info) do
    %{
      name: user_info[:display_name],
      avatar: user_info[:avatar_url],
      credential: %{
        email: user_info[:email],
        username: user_info[:username],
        provider: :spotify
      }
    }
  end
end
