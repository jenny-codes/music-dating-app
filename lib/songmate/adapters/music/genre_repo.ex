defmodule Songmate.Music.GenreRepo do
  @moduledoc """
  The Music context.
  """

  import Ecto.Query, warn: false
  alias Songmate.Repo
  alias Songmate.Music.Genre

  @callback batch_get_or_create_genres([%Genre{}], order: boolean()) :: [Genre]

  @spec batch_get_or_create_genres([%Genre{}], order: boolean()) :: [Genre]
  def batch_get_or_create_genres([], _), do: []

  def batch_get_or_create_genres(genres, order: true) do
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
