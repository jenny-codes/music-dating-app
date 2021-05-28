defmodule Songmate.Music.Track do
  use Ecto.Schema
  import Ecto.Changeset

  alias Songmate.Music.Artist

  schema "tracks" do
    field(:isrc, :string)
    field(:name, :string)
    field(:popularity, :integer)
    field(:spotify_id, :string)

    many_to_many(:artists, Artist, join_through: "artists_tracks", on_replace: :delete)
  end

  @doc false
  def changeset(track, attrs) do
    track
    |> cast(attrs, [:isrc, :spotify_id, :name, :popularity])
    |> validate_required([:spotify_id, :name])
    |> unique_constraint(:spotify_id)
    |> unique_constraint(:isrc)
  end
end
