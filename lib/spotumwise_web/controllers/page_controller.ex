defmodule SpotumwiseWeb.PageController do
  use SpotumwiseWeb, :controller
  alias Spotumwise.Repo
  alias Spotumwise.User

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
    [id: id, name: name] = SpotifyService.fetch_user_id_and_name(conn)
    tops = SpotifyService.fetch_tops(conn)

    user =
      Repo.get_by(User, spotify_id: id) ||
        Repo.insert(%User{name: name, spotify_id: id}) |> elem(1)

    changeset =
      Ecto.Changeset.change(user,
        top_tracks: tops[:track_names],
        top_artists: tops[:artist_names],
        genres: tops[:genres]
      )

    user = Repo.update!(changeset)

    top3_matches = User.build_user_connections(user)

    render(conn, "index.html",
      name: name,
      top_tracks: user.top_tracks,
      top_artists: user.top_artists,
      top_genres: user.genres,
      top_matches: top3_matches
    )
  end
  
  def info(conn, _params) do
	render(conn, "info.html")
  end

  
  def login(conn, _params) do
	render(conn, "login.html")
  end

  
  def music(conn, _params) do
	render(conn, "music.html")
  end

  
  def chat(conn, _params) do
	render(conn, "chat.html")
  end

    
end
