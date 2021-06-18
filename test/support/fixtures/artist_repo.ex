defmodule Songmate.Fixtures.ArtistRepo do
  alias Songmate.Music.ArtistRepo
  @behaviour ArtistRepo

  @impl ArtistRepo
  def batch_get_or_create_artists(_artist_attrs, order: true) do
    []
  end
end
