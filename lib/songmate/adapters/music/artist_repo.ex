defmodule Songmate.Music.ArtistRepo do
  import Ecto.Query, warn: false
  alias Songmate.Repo
  alias Songmate.Music.{Genre, Artist}

  @callback batch_get_or_create_artists([%Artist{}], order: boolean()) :: [
              Artist
            ]

  @spec batch_get_or_create_artists([%Artist{}], order: boolean()) :: [Artist]
  def batch_get_or_create_artists([], _), do: []

  def batch_get_or_create_artists(artists, order: true) do
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
end
