defmodule SongmateWeb.AuthPlug do
  import Plug.Conn

  @auth_service Application.compile_env(
                  :songmate,
                  [:services, :auth_service],
                  Songmate.AuthService
                )

  def init(options) do
    options
  end

  def call(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      case @auth_service.fetch_user_with_token(conn) do
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
