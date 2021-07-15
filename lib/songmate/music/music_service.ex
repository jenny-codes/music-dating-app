defmodule Songmate.MusicService do
  alias Songmate.Music.{Artist, Track, Genre}
  import Ecto.Query, warn: false
  alias Songmate.Repo

  def batch_get_music_records(%{artist: artist_ids, track: track_ids, genre: genre_ids}) do
    %{
      artist: get_artists(artist_ids),
      track: get_tracks(track_ids),
      genre: get_genres(genre_ids)
    }
  end

  def type_for(struct) do
    case struct.__struct__ do
      Artist -> :artist
      Track -> :track
      Genre -> :genre
    end
  end

  def get(:artist, ids) do
    get_artists(ids)
  end

  def get(:track, ids) do
    get_tracks(ids)
  end

  def get(:genre, ids) do
    get_genres(ids)
  end

  @callback batch_create_artists([%Artist{}], order: boolean()) :: [Artist.t()]
  @callback get_artists([integer()]) :: [Artist.t()]

  def batch_create_artists([], _), do: []

  def batch_create_artists(artists, order: true) do
    Repo.insert_all(Artist, artists, on_conflict: :nothing)
    Repo.all_with_order(Artist, :spotify_id, Enum.map(artists, & &1.spotify_id))
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

  def get_artists(ids) do
    Repo.all(from(a in Artist, where: a.id in ^ids))
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

  @callback batch_create_tracks([%Track{}], order: boolean()) :: [Track.t()]
  @callback get_tracks([integer()]) :: [Track.t()]

  def batch_create_tracks([], _), do: []

  def batch_create_tracks(tracks, order: true) do
    Repo.insert_all(Track, tracks, on_conflict: :nothing)
    Repo.all_with_order(Track, :spotify_id, Enum.map(tracks, & &1.spotify_id))
  end

  def get_tracks(ids) do
    Repo.all(from(t in Track, where: t.id in ^ids))
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

  @callback batch_create_genres([%Genre{}], order: boolean()) :: [Genre.t()]
  @callback get_genres([integer()]) :: [Genre.t()]

  def batch_create_genres([], _), do: []

  def batch_create_genres(genres, order: true) do
    Repo.insert_all(Genre, genres, on_conflict: :nothing)
    Repo.all_with_order(Genre, :name, Enum.map(genres, & &1.name))
  end

  def get_genres(ids) do
    Repo.all(from(g in Genre, where: g.id in ^ids))
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
