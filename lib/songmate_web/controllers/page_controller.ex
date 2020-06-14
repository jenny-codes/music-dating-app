defmodule SongmateWeb.PageController do
  use SongmateWeb, :controller
  alias Songmate.Repo
  alias Songmate.Accounts.User
  alias Songmate.Accounts
  alias Songmate.MusicProfile

  plug :check_tokens

  def check_tokens(conn, _params) do
    if Spotify.Authentication.tokens_present?(conn) do
      {:ok, conn} = Spotify.Authentication.refresh(conn)

      conn
    else
      redirect(conn, to: "/authorize")
    end
  end

  def index(conn, _params) do
    {user, profile} = build_current_profile(conn)

    render(
      conn,
      "index.html",
      name: user.name,
      top_tracks: profile.track_preferences
                  |> Enum.map(&(&1.track.name)),
      top_artists: profile.artist_preferences
                   |> Enum.map(&(&1.artist.name)),
      top_genres: profile.genre_preferences
                  |> Enum.map(&(&1.genre.name)),
      top_matches: []
    )
  end

  defp build_current_profile(conn) do
    profile_attrs = SpotifyService.fetch_user_info(conn)

    user = case Accounts.get_user_by_username(profile_attrs[:username]) do
      nil ->
        {:ok, user} = Accounts.create_user(
          %{
            name: profile_attrs[:display_name],
            avatar: profile_attrs[:avatar_url],
            credential: %{
              email: profile_attrs[:email],
              username: profile_attrs[:username],
              provider: :spotify
            }
          }
        )
        user
      user -> user
    end

    tops = SpotifyService.fetch_tops(conn)

    profile = MusicProfile.create_or_update_profile(
                %{
                  user: user,
                  artist_preferences: build_preferences(:artist, tops[:artists]),
                  track_preferences: build_preferences(:track, tops[:tracks]),
                  genre_preferences: build_preferences(:genre, tops[:genres])
                }
              )
              |> Repo.preload([[artist_preferences: :artist], [track_preferences: :track], [genre_preferences: :genre]])

    {user, profile}
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
