defmodule SongmateWeb.PageController do
  use SongmateWeb, :controller
  alias Songmate.Repo
  alias Songmate.Accounts
  alias Songmate.MusicProfile

  def index(conn, _params) do
    user = conn.assigns.current_user |> build_music_profile(conn)

    user_prefs = %{
      top_tracks: user.track_preferences |> Enum.map(& &1.track.name),
      top_artists: user.artist_preferences |> Enum.map(& &1.artist.name),
      top_genres: user.genre_preferences |> Enum.map(& &1.genre.name)
    }

    render(
      conn,
      "index.html",
      name: user.name,
      top_tracks: user_prefs[:top_tracks],
      top_artists: user_prefs[:top_artists],
      top_genres: user_prefs[:top_genres],
      top_matches: Accounts.User.build_user_connections(user_prefs)
    )
  end

  # """
  # New database records for
  # 1. Profile
  # 2. artists & tracks & genres
  # 3. artists & tracks & genres preferences
  # """
  defp build_music_profile(user, conn) do
    tops = SpotifyService.fetch_tops(conn)

    MusicProfile.create_music_profile(user, %{
      artist_preferences: build_preferences(:artist, tops[:artists]),
      track_preferences: build_preferences(:track, tops[:tracks]),
      genre_preferences: build_preferences(:genre, tops[:genres])
    })
    |> Repo.preload([
      [artist_preferences: :artist],
      [track_preferences: [track: :artists]],
      [genre_preferences: :genre]
    ])
  end

  def build_preferences(label, data) do
    data
    |> Enum.with_index()
    |> Enum.map(fn {row, idx} -> %{label => row, :rank => idx} end)
  end

  def info(conn, _params) do
    render(conn, "info.html")
  end

  def login(conn, _params) do
    render(conn, "login.html")
  end

  def music(conn, _params) do
    render(conn, "music.html", top_matches: [])
  end

  def chat(conn, _params) do
    render(conn, "chat.html")
  end
end
