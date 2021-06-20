defmodule Songmate.Fixtures.ArtistService do
  alias Songmate.Music.ArtistService
  @behaviour ArtistService

  @impl ArtistService
  def batch_get_or_create_artists(_artist_attrs, order: true) do
    []
  end
end
