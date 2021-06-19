defmodule SongmateWeb.AuthPlug do
  import Plug.Conn
  alias Songmate.AuthService

  def init(options) do
    options
  end

  def call(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      with {:ok, conn} <- AuthService.validate_and_refresh_token(conn),
           {:ok, user} <- AuthService.fetch_user(conn) do
        assign(conn, :current_user, user)
      else
        _ ->
          conn
          |> put_session(:login_dest, conn.request_path)
          |> Phoenix.Controller.redirect(to: "/authorize")
          |> halt
      end
    end
  end
end
