defmodule Songmate.Fixtures.TrackRepo do
  alias Songmate.Music.TrackRepo
  @behaviour TrackRepo

  @impl TrackRepo
  def batch_get_or_create_tracks(_tracks_attrs, order: true) do
    []
  end
end
