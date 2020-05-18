defmodule SpotumwiseWeb.UserController do
  use SpotumwiseWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

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
end
