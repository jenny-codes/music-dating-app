defmodule Songmate.Fixtures.MusicService do
  alias Songmate.MusicService
  @behaviour MusicService

  @impl MusicService
  def batch_create_artists(_artist_attrs, order: true) do
    []
  end

  @impl MusicService
  def get_artists(ids) do
    Enum.map(ids, &%{id: &1})
  end

  @impl MusicService
  def batch_create_tracks(_tracks_attrs, order: true) do
    []
  end

  @impl MusicService
  def get_tracks(ids) do
    Enum.map(ids, &%{id: &1})
  end

  @impl MusicService
  def batch_create_genres(_genres_attrs, order: true) do
    []
  end

  @impl MusicService
  def get_genres(ids) do
    Enum.map(ids, &%{id: &1})
  end
end
