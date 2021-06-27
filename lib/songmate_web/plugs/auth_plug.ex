defmodule SongmateWeb.AuthPlug do
  import Plug.Conn

  def init(options) do
    options
  end

  def call(conn, opts) do
    auth_service = opts[:auth_service] || Songmate.AuthService

    if conn.assigns[:current_user] do
      conn
    else
      case auth_service.fetch_user_with_token(conn) do
        {conn, user} ->
          assign(conn, :current_user, user)

        nil ->
          conn
          |> put_session(:login_dest, conn.request_path)
          |> Phoenix.Controller.redirect(to: "/authorize")
          |> halt
      end
    end
  end
end
