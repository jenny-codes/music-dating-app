defmodule Songmate.Fixtures.Music do
  @behaviour Songmate.Music

  @impl Songmate.Music
  def batch_get_or_create_artists(_artist_attrs, order: true) do
    []
  end

  @impl Songmate.Music
  def batch_get_or_create_tracks(_tracks_attrs, order: true) do
    []
  end

  @impl Songmate.Music
  def batch_get_or_create_genres(_genres_attrs, order: true) do
    []
  end
end
