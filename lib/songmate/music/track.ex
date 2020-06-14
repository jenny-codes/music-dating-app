defmodule Songmate.Music.Track do
  use Ecto.Schema
  import Ecto.Changeset

  alias Songmate.Music.{Artist, Track}
  alias Songmate.Repo

  schema "tracks" do
    field :isrc, :string
    field :name, :string
    field :popularity, :integer
    field :spotify_id, :string

    many_to_many :artists, Artist, join_through: "artists_tracks", on_replace: :delete
  end

  @doc false
  def changeset(track, attrs) do
    track
    |> cast(attrs, [:isrc, :spotify_id, :name, :popularity])
    |> validate_required([:spotify_id, :name])
    |> unique_constraint(:spotify_id)
    |> unique_constraint(:isrc)
  end

  def get_or_create_by!(attr_name, attrs) do
    Repo.get_by(Track, [{attr_name, attrs[attr_name]}]) || Repo.insert!(Track.changeset(%Track{}, attrs))
  end
end
