defmodule Songmate.Fixtures.GenreService do
  alias Songmate.Music.GenreService
  @behaviour GenreService

  @impl GenreService
  def batch_get_or_create_genres(_genres_attrs, order: true) do
    []
  end
end
