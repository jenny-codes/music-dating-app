defmodule Songmate.MusicFactory do
  alias Songmate.Music.{ArtistService, TrackService, GenreService}

  def create_artist(attrs \\ %{}) do
    salt = random_string()

    {:ok, artist} =
      attrs
      |> Enum.into(%{
        name: "artist#{salt}",
        popularity: 53,
        spotify_id: "spoid#{salt}"
      })
      |> ArtistService.create_artist()

    artist
  end

  def create_track(attrs \\ %{}) do
    salt = random_string()

    {:ok, track} =
      attrs
      |> Enum.into(%{
        isrc: "ISRC#{salt}",
        name: "track#{salt}",
        popularity: 100,
        spotify_id: "spoid#{salt}"
      })
      |> TrackService.create_track()

    track
  end

  def create_genre(attrs \\ %{}) do
    salt = random_string()

    {:ok, genre} =
      attrs
      |> Enum.into(%{name: "Genre#{salt}"})
      |> GenreService.create_genre()

    genre
  end

  defp random_string do
    8
    |> :crypto.strong_rand_bytes()
    |> Base.encode16()
    |> String.downcase()
  end
end
