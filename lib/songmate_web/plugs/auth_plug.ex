defmodule SongmateWeb.AuthPlug do
  import Plug.Conn
  alias Songmate.Accounts.UserRepo

  def init(options) do
    options
  end

  def call(conn, _opts) do
    cond do
      conn.assigns[:current_user] ->
        conn

      get_session(conn, :current_user_id) ->
        case UserRepo.get_user(get_session(conn, :current_user_id)) do
          nil -> redirect_to_login(conn)
          user -> assign(conn, :current_user, user)
        end

      true ->
        redirect_to_login(conn)
    end
  end

  defp redirect_to_login(conn) do
    conn
    |> put_session(:login_dest, conn.request_path)
    |> Phoenix.Controller.redirect(to: "/login")
    |> halt
  end
end
