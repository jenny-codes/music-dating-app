defmodule Songmate.Music do
  @moduledoc """
  The Music context.
  """

  import Ecto.Query, warn: false
  alias Songmate.Repo
  alias Songmate.Music.{Track, Genre, Artist}

  def batch_get_or_insert_artists(attrs) do
  end

  def find_or_create_by(:artist, attr, attrs) do
    case Repo.get_by(Artist, attr, attrs[attr]) do
      nil ->
        {:ok, artist} = create_artist(attrs)
        artist

      artist ->
        artist
    end
  end

  def find_or_create_by(:track, attr, attrs) do
    case Repo.get_by(Track, attr, attrs[attr]) do
      nil ->
        {:ok, track} = create_track(attrs)
        track

      track ->
        track
    end
  end

  def find_or_create_by(:genre, attr, attrs) do
    case Repo.get_by(Genre, attr, attrs[attr]) do
      nil ->
        {:ok, genre} = create_genre(attrs)
        genre

      genre ->
        genre
    end
  end

  @doc """
  Returns the list of tracks.

  ## Examples

      iex> list_tracks()
      [%Track{}, ...]

  """
  def list_tracks do
    Repo.all(Track)
  end

  @doc """
  Gets a single track.

  Raises `Ecto.NoResultsError` if the Track does not exist.

  ## Examples

      iex> get_track!(123)
      %Track{}

      iex> get_track!(456)
      ** (Ecto.NoResultsError)

  """
  def get_track!(id), do: Repo.get!(Track, id)

  @doc """
  Creates a track.

  ## Examples

      iex> create_track(%{field: value})
      {:ok, %Track{}}

      iex> create_track(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
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

  @doc """
  Deletes a track.

  ## Examples

      iex> delete_track(track)
      {:ok, %Track{}}

      iex> delete_track(track)
      {:error, %Ecto.Changeset{}}

  """
  def delete_track(%Track{} = track) do
    Repo.delete(track)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking track changes.

  ## Examples

      iex> change_track(track)
      %Ecto.Changeset{source: %Track{}}

  """
  def change_track(%Track{} = track) do
    Track.changeset(track, %{})
  end

  alias Songmate.Music.Artist

  @doc """
  Returns the list of artists.

  ## Examples

      iex> list_artists()
      [%Artist{}, ...]

  """
  def list_artists do
    Repo.all(Artist)
  end

  @doc """
  Gets a single artist.

  Raises `Ecto.NoResultsError` if the Artist does not exist.

  ## Examples

      iex> get_artist!(123)
      %Artist{}

      iex> get_artist!(456)
      ** (Ecto.NoResultsError)

  """
  def get_artist!(id), do: Repo.get!(Artist, id)

  @doc """
  Creates a artist.

  ## Examples

      iex> create_artist(%{field: value})
      {:ok, %Artist{}}

      iex> create_artist(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
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

  @doc """
  Updates a artist.

  ## Examples

      iex> update_artist(artist, %{field: new_value})
      {:ok, %Artist{}}

      iex> update_artist(artist, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
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

  @doc """
  Deletes a artist.

  ## Examples

      iex> delete_artist(artist)
      {:ok, %Artist{}}

      iex> delete_artist(artist)
      {:error, %Ecto.Changeset{}}

  """
  def delete_artist(%Artist{} = artist) do
    Repo.delete(artist)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking artist changes.

  ## Examples

      iex> change_artist(artist)
      %Ecto.Changeset{source: %Artist{}}

  """
  def change_artist(%Artist{} = artist) do
    Artist.changeset(artist, %{})
  end

  alias Songmate.Music.Genre

  @doc """
  Returns the list of genres.

  ## Examples

      iex> list_genres()
      [%Genre{}, ...]

  """
  def list_genres do
    Repo.all(Genre)
  end

  @doc """
  Gets a single genre.

  Raises `Ecto.NoResultsError` if the Genre does not exist.

  ## Examples

      iex> get_genre!(123)
      %Genre{}

      iex> get_genre!(456)
      ** (Ecto.NoResultsError)

  """
  def get_genre!(id), do: Repo.get!(Genre, id)

  @doc """
  Creates a genre.

  ## Examples

      iex> create_genre(%{field: value})
      {:ok, %Genre{}}

      iex> create_genre(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_genre(attrs \\ %{}) do
    %Genre{}
    |> Genre.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a genre.

  ## Examples

      iex> update_genre(genre, %{field: new_value})
      {:ok, %Genre{}}

      iex> update_genre(genre, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_genre(%Genre{} = genre, attrs) do
    genre
    |> Genre.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a genre.

  ## Examples

      iex> delete_genre(genre)
      {:ok, %Genre{}}

      iex> delete_genre(genre)
      {:error, %Ecto.Changeset{}}

  """
  def delete_genre(%Genre{} = genre) do
    Repo.delete(genre)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking genre changes.

  ## Examples

      iex> change_genre(genre)
      %Ecto.Changeset{source: %Genre{}}

  """
  def change_genre(%Genre{} = genre) do
    Genre.changeset(genre, %{})
  end
end
