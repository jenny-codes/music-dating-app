defmodule Songmate.Importer.SpotifyService do
  @spotify_port Spotify.Personalization

  @type artist :: %{
          name: String.t(),
          spotify_id: String.t(),
          popularity: non_neg_integer()
        }

  @type track :: %{
          name: String.t(),
          isrc: String.t(),
          spotify_id: String.t(),
          popularity: non_neg_integer()
        }

  @type genre :: %{
          name: String.t()
        }

  @callback listening_history(%{__struct__: Plug.Conn}) :: %{
              artists: [artist],
              tracks: [track],
              genres: [genre]
            }

  def listening_history(conn) do
    {artists, genres} = fetch_top_artists_and_genres(conn)
    tracks = fetch_top_tracks(conn)

    %{artists: artists, tracks: tracks, genres: genres}
  end

  @spec fetch_top_tracks(%{__struct__: Plug.Conn}) :: [track]
  defp fetch_top_tracks(conn) do
    {:ok, %{items: tracks}} = @spotify_port.top_tracks(conn, limit: 50, time_range: "medium_term")

    # There is an "artists" field for each track, but we don't parse that for now.
    Enum.map(tracks, fn track ->
      %{
        name: track.name,
        isrc: track.external_ids["isrc"],
        spotify_id: track.id,
        popularity: track.popularity
      }
    end)
  end

  @spec fetch_top_artists_and_genres(%Plug.Conn{}) :: {[artist()], [genre]}
  defp fetch_top_artists_and_genres(conn) do
    {:ok, %{items: artists}} =
      @spotify_port.top_artists(conn, limit: 50, time_range: "medium_term")

    artist_records =
      Enum.map(artists, fn artist ->
        %{
          name: artist.name,
          spotify_id: artist.id,
          popularity: artist.popularity
        }
      end)

    genre_records =
      artists
      |> Enum.flat_map(& &1.genres)
      |> Enum.frequencies()
      |> Enum.sort_by(&elem(&1, 1), :desc)
      |> Enum.take(30)
      |> Enum.map(&elem(&1, 0))
      |> Enum.map(fn genre ->
        %{
          name: genre
        }
      end)

    {artist_records, genre_records}
  end
end
