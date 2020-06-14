defmodule Songmate.Music.Artist do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Songmate.Repo
  alias Songmate.Music.{Artist, Track, Genre}

  schema "artists" do
    field(:name, :string)
    field(:spotify_id, :string)
    field(:popularity, :integer)

    many_to_many(:tracks, Track, join_through: "artists_tracks", on_replace: :delete)
    many_to_many(:genres, Genre, join_through: "artists_genres", on_replace: :delete)
  end

  @doc false
  def changeset(artist, attrs) do
    artist
    |> cast(attrs, [:spotify_id, :name, :popularity])
    |> validate_required([:spotify_id, :name])
    |> unique_constraint(:spotify_id)
  end

  def insert_and_get_all([]), do: []

  def insert_and_get_all(artists) do
    Repo.insert_all(Artist, artists, on_conflict: :nothing, conflict_target: :spotify_id)
    spotify_ids = Enum.map(artists, & &1.spotify_id)
    Repo.all(from(a in Artist, where: a.spotify_id in ^spotify_ids))
  end

  def get_or_create_by!(attr_name, attrs) do
    Repo.get_by(Artist, [{attr_name, Map.get(attrs, attr_name)}]) || Repo.insert!(Artist.changeset(%Artist{}, attrs))
  end
end
