defmodule Songmate.Fixtures.GenreRepo do
  alias Songmate.Music.GenreRepo
  @behaviour GenreRepo

  @impl GenreRepo
  def batch_get_or_create_genres(_genres_attrs, order: true) do
    []
  end
end
