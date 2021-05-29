defmodule Songmate.SpotifyService do
  # ---------------------------------------------------------
  # Auths

  def validate_and_refresh_token(conn) do
    with true <- Spotify.Authentication.tokens_present?(conn),
         {:ok, conn} <- Spotify.Authentication.refresh(conn) do
      {:ok, conn}
    end
  end

  def authorize_url do
    Spotify.Authorization.url()
  end

  def authenticate(conn, params) do
    Spotify.Authentication.authenticate(conn, params)
  end

  # ---------------------------------------------------------
  # User data

  @type user :: %{
          email: String.t(),
          username: String.t(),
          avatar_url: String.t(),
          display_name: String.t()
        }

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

  @spec fetch_user_info(%{__struct__: Plug.Conn}) :: user()
  def fetch_user_info(conn) do
    {:ok, profile} = Spotify.Profile.me(conn)

    %{
      email: profile.email,
      username: profile.id,
      avatar_url: List.first(profile.images)["url"],
      display_name: profile.display_name
    }
  end

  @spec fetch_listening_history(%{__struct__: Plug.Conn}) :: [
          artists: [artist],
          tracks: [track],
          genres: [genre]
        ]
  def fetch_listening_history(conn) do
    {artists, genres} = fetch_top_artists_and_genres(conn)
    tracks = fetch_top_tracks(conn)

    [artists: artists, tracks: tracks, genres: genres]
  end

  @spec fetch_top_tracks(%{__struct__: Plug.Conn}) :: [track]
  defp fetch_top_tracks(conn) do
    {:ok, %{items: tracks}} =
      Spotify.Personalization.top_tracks(conn, limit: 50, time_range: "medium_term")

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
      Spotify.Personalization.top_artists(conn, limit: 50, time_range: "medium_term")

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
      |> Enum.uniq()
      |> Enum.map(fn genre ->
        %{
          name: genre
        }
      end)

    {artist_records, genre_records}
  end
end
