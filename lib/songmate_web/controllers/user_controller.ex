defmodule SongmateWeb.UserController do
  use SongmateWeb, :controller
  alias Songmate.ImportMusicService
  alias Songmate.Workers.UpdateUserMusicPreferences
  alias Songmate.Community.MatchingService

  def index(conn, _params) do
    conn = validate_token(conn)
    user = conn.assigns.current_user

    [artists: artists, tracks: tracks, genres: genres] =
      ImportMusicService.fetch_listening_history(conn)

    UpdateUserMusicPreferences.call(user, %{artists: artists, tracks: tracks, genres: genres})

    %{user: user, score: score, shared: shared} = MatchingService.find_top_match(user)

    render(
      conn,
      "index.html",
      shared_artists: Enum.map(shared[:artists], & &1.name),
      shared_tracks: Enum.map(shared[:tracks], & &1.name),
      shared_genres: Enum.map(shared[:genres], & &1.name),
      match_user: user,
      score: score
    )
  end

  def chat(conn, _params) do
    render(conn, "chat.html")
  end

  defp validate_token(conn) do
    case Songmate.AuthService.validate_and_refresh_token(conn) do
      {:ok, conn} ->
        conn

      _ ->
        conn
        |> put_session(:login_dest, conn.request_path)
        |> redirect(to: "/authorize")
    end
  end
end
