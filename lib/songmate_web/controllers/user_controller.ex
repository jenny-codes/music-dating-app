defmodule SongmateWeb.UserController do
  use SongmateWeb, :controller
  alias Songmate.MusicPreferences
  alias Songmate.SpotifyService

  def index(conn, _params) do
    user = conn.assigns.current_user

    [artists: artists, tracks: tracks, genres: genres] =
      SpotifyService.fetch_listening_history(conn)

    artists
    |> Music.batch_get_or_create_artists()
    |> MusicPreferences.batch_create_artist_preferences!(user)

    tracks
    |> Music.batch_get_or_create_tracks()
    |> MusicPreferences.batch_create_track_preferences!(user)

    genres
    |> Music.batch_get_or_create_genres()
    |> MusicPreferences.batch_create_genre_preferences!(user)

    render(
      conn,
      "index.html",
      top_tracks: Enum.map(tracks, & &1.name),
      top_artists: Enum.map(artists, & &1.name),
      top_genres: Enum.map(genres, & &1.name),
      # top_matches: Accounts.User.build_user_connections(user_prefs)
      top_matches: []
    )
  end

  def chat(conn, _params) do
    render(conn, "chat.html")
  end

  defp with_rank(data) do
    data
    |> Enum.with_index()
    |> Enum.map(fn {row, idx} -> {idx, row} end)
  end
end
