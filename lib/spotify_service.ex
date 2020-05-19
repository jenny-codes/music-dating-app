defmodule SpotifyService do
  @moduledoc """
  """

  def fetch_user_id_and_name(conn) do
    {:ok, profile} = Spotify.Profile.me(conn)

    [id: profile.id, name: profile.display_name]
  end

  def fetch_tops(conn) do
    track_names =
      fetch_top_tracks(conn)
      |> Enum.map(fn track ->
        artist_names = track.artists |> Enum.map(& &1["name"]) |> Enum.join(", ")
        "#{track.name} by #{artist_names}"
      end)

    artists = fetch_top_artists(conn)

    artist_names = Enum.map(artists, & &1.name)
    genres = calculate_top_genres(artists)

    [track_names: track_names, artist_names: artist_names, genres: genres]
  end

  @spec fetch_top_tracks(%{__struct__: Plug.Conn | Spotify.Credentials}) :: [Spotify.Track]
  def fetch_top_tracks(conn) do
    {:ok, %{items: tracks}} =
      Spotify.Personalization.top_tracks(conn, limit: 50, time_range: "long_term")

    tracks
  end

  @spec fetch_top_artists(%{__struct__: Plug.Conn | Spotify.Credentials}) :: [Spotify.Artist]
  def fetch_top_artists(conn) do
    {:ok, %{items: artists}} =
      Spotify.Personalization.top_artists(conn, limit: 50, time_range: "long_term")

    artists
  end

  def calculate_top_genres(top_artists) do
    top_artists
    |> Enum.flat_map(& &1.genres)
    |> Enum.uniq()
  end
end
