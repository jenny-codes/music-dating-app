defmodule SpotifyService do
  @moduledoc """
  """

  def fetch_user_info(conn) do
    {:ok, profile} = Spotify.Profile.me(conn)

    [
      email: profile.email,
      username: profile.id,
      avatar_url: List.first(profile.images)["url"],
      display_name: profile.display_name
    ]
  end

  def fetch_tops(conn) do
    #      |> Enum.map(
    #           fn track ->
    #             artist_names = track.artists
    #                            |> Enum.map(& &1["name"])
    #                            |> Enum.join(", ")
    #             "#{track.name} by #{artist_names}"
    #           end
    #         )

    artists = fetch_top_artists(conn)
    tracks = fetch_top_tracks(conn)
    genres = calculate_top_genres(artists)

    [tracks: tracks, artists: artists, genres: genres]
  end

  @spec fetch_top_tracks(%{__struct__: Plug.Conn | Spotify.Credentials}) :: [Songmate.Music.Track]
  def fetch_top_tracks(conn) do
    {:ok, %{items: tracks}} =
      Spotify.Personalization.top_tracks(conn, limit: 50, time_range: "medium_term")

    Enum.map(tracks, &format_track_attrs/1)
  end

  def format_track_attrs(track) do
    %{
      name: track.name,
      isrc: track.external_ids["isrc"],
      spotify_id: track.id,
      popularity: track.popularity,
      artists: track.artists
               |> Enum.map(fn artist -> %{name: artist["name"], spotify_id: artist["spotify_id"]} end)
    }
  end

  @spec fetch_top_artists(%{__struct__: Plug.Conn | Spotify.Credentials}) :: [Songmate.Music.Artist]
  def fetch_top_artists(conn) do
    {:ok, %{items: artists}} =
      Spotify.Personalization.top_artists(conn, limit: 50, time_range: "medium_term")

    Enum.map(artists, &format_artist_attrs/1)
  end

  def format_artist_attrs(artist) do
    %{
      name: artist.name,
      spotify_id: artist.id,
      popularity: artist.popularity,
      genres: artist.genres
              |> Enum.map(&format_genre_attrs/1)
    }
  end

  def format_genre_attrs(genre) do
    %{
      name: genre
    }
  end

  def calculate_top_genres(top_artists) do
    top_artists
    |> Enum.flat_map(& &1.genres)
    |> Enum.uniq()
  end
end
