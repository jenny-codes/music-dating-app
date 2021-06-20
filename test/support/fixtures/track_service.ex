defmodule Songmate.Fixtures.TrackService do
  alias Songmate.Music.TrackService
  @behaviour TrackService

  @impl TrackService
  def batch_get_or_create_tracks(_tracks_attrs, order: true) do
    []
  end
end
