defmodule SongmateWeb.UserController do
  use SongmateWeb, :controller
  alias Songmate.SpotifyService
  alias Songmate.Workers.UpdateUserMusicPreferences

  def index(conn, _params) do
    conn = validate_token(conn)
    user = conn.assigns.current_user

    [artists: artists, tracks: tracks, genres: genres] =
      SpotifyService.fetch_listening_history(conn)

    UpdateUserMusicPreferences.call(user, artists: artists, tracks: tracks, genres: genres)

    render(
      conn,
      "index.html",
      top_artists: Enum.map(artists, & &1.name),
      top_tracks: Enum.map(tracks, & &1.name),
      top_genres: Enum.map(genres, & &1.name),
      # top_matches: Accounts.User.build_user_connections(user_prefs)
      top_matches: []
    )
  end

  def chat(conn, _params) do
    render(conn, "chat.html")
  end

  defp validate_token(conn) do
    case SpotifyService.validate_and_refresh_token(conn) do
      {:ok, conn} ->
        conn

      _ ->
        conn
        |> put_session(:login_dest, conn.request_path)
        |> redirect(to: "/authorize")
    end
  end
end
