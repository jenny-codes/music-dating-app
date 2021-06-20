defmodule Songmate.Music.TrackService do
  import Ecto.Query, warn: false
  alias Songmate.Repo
  alias Songmate.Music.{Track, Artist}

  @callback batch_get_or_create_tracks([%Track{}], order: boolean()) :: [Track]

  @spec batch_get_or_create_tracks([%Track{}], order: boolean()) :: [Track]
  def batch_get_or_create_tracks([], _), do: []

  def batch_get_or_create_tracks(tracks, order: true) do
    Repo.insert_all(Track, tracks, on_conflict: :nothing)
    Repo.all_with_order(Track, :spotify_id, Enum.map(tracks, & &1.spotify_id))
  end

  def get_tracks(ids) do
    Repo.all(from(t in Track, where: t.id in ^ids))
  end

  def create_track(attrs \\ %{}) do
    changeset =
      if attrs[:artists] do
        %Track{}
        |> Track.changeset(attrs)
        |> Ecto.Changeset.put_assoc(:artists, Artist.insert_and_get_all(attrs[:artists]))
      else
        Track.changeset(%Track{}, attrs)
      end

    Repo.insert(changeset)
  end

  @doc """
  Updates a track.

  ## Examples

      iex> update_track(track, %{field: new_value})
      {:ok, %Track{}}

      iex> update_track(track, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_track(%Track{} = track, attrs) do
    changeset =
      if attrs[:artists] do
        track
        |> Repo.preload(:artists)
        |> Track.changeset(attrs)
        |> Ecto.Changeset.put_assoc(:artists, Artist.insert_and_get_all(attrs[:artists]))
      else
        Track.changeset(track, attrs)
      end

    Repo.update(changeset)
  end
end
