defmodule Songmate.Music do
  @moduledoc """
  The Music context.
  """

  import Ecto.Query, warn: false
  alias Songmate.Repo
  alias Songmate.SpotifyService
  alias Songmate.Music.{Track, Genre, Artist}

  @callback batch_get_or_create_artists([SpotifyService.artist()], order: boolean()) :: [Artist]
  @callback batch_get_or_create_tracks([SpotifyService.track()], order: boolean()) :: [Track]
  @callback batch_get_or_create_genres([SpotifyService.genre()], order: boolean()) :: [Genre]

  @spec batch_get_or_create_artists([SpotifyService.artist()], order: boolean()) :: [Artist]
  def batch_get_or_create_artists([], _), do: []

  def batch_get_or_create_artists(artists, order: true) do
    Repo.insert_all(Artist, artists, on_conflict: :nothing)
    Repo.all_with_order(Artist, :spotify_id, Enum.map(artists, & &1.spotify_id))
  end

  @spec batch_get_or_create_tracks([SpotifyService.track()], order: boolean()) :: [Track]
  def batch_get_or_create_tracks([], _), do: []

  def batch_get_or_create_tracks(tracks, order: true) do
    Repo.insert_all(Track, tracks, on_conflict: :nothing)
    Repo.all_with_order(Track, :spotify_id, Enum.map(tracks, & &1.spotify_id))
  end

  @spec batch_get_or_create_genres([SpotifyService.genre()], order: boolean()) :: [Genre]
  def batch_get_or_create_genres([], _), do: []

  def batch_get_or_create_genres(genres, order: true) do
    Repo.insert_all(Genre, genres, on_conflict: :nothing)
    Repo.all_with_order(Genre, :name, Enum.map(genres, & &1.name))
  end

  def create_track(attrs \\ %{}) do
    changeset =
      if attrs[:artists] do
        %Track{}
        |> Track.changeset(attrs)
        |> Ecto.Changeset.put_assoc(:artists, Artist.insert_and_get_all(attrs[:artists]))
      else
        Track.changeset(%Track{}, attrs)
      end

    Repo.insert(changeset)
  end

  @doc """
  Updates a track.

  ## Examples

      iex> update_track(track, %{field: new_value})
      {:ok, %Track{}}

      iex> update_track(track, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_track(%Track{} = track, attrs) do
    changeset =
      if attrs[:artists] do
        track
        |> Repo.preload(:artists)
        |> Track.changeset(attrs)
        |> Ecto.Changeset.put_assoc(:artists, Artist.insert_and_get_all(attrs[:artists]))
      else
        Track.changeset(track, attrs)
      end

    Repo.update(changeset)
  end

  def create_artist(attrs \\ %{}) do
    changeset =
      if attrs[:genres] do
        %Artist{}
        |> Artist.changeset(attrs)
        |> Ecto.Changeset.put_assoc(:genres, Genre.insert_and_get_all(attrs[:genres]))
      else
        Artist.changeset(%Artist{}, attrs)
      end

    Repo.insert(changeset)
  end

  def update_artist(%Artist{} = artist, attrs) do
    changeset =
      if attrs[:genres] do
        artist
        |> Repo.preload(:genres)
        |> Artist.changeset(attrs)
        |> Ecto.Changeset.put_assoc(:genres, Genre.insert_and_get_all(attrs[:genres]))
      else
        Artist.changeset(artist, attrs)
      end

    Repo.update(changeset)
  end

  def create_genre(attrs \\ %{}) do
    %Genre{}
    |> Genre.changeset(attrs)
    |> Repo.insert()
  end

  def update_genre(%Genre{} = genre, attrs) do
    genre
    |> Genre.changeset(attrs)
    |> Repo.update()
  end
end
