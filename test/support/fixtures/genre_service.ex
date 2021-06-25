defmodule Songmate.Fixtures.GenreService do
  alias Songmate.Music.GenreService
  @behaviour GenreService

  @impl GenreService
  def batch_create_genres(_genres_attrs, order: true) do
    []
  end

  @impl GenreService
  def get_genres(ids) do
    Enum.map(ids, &%{id: &1})
  end
end
