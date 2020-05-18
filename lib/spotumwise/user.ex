defmodule Spotumwise.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Spotumwise.User

  schema "users" do
    field :bio, :string
    field :name, :string
    field :spotify_id, :binary_id
    field :fav_track, :string
    field :top_tracks, {:array, :string}
    field :top_artists, {:array, :string}
    field :genres, {:array, :string}

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :bio, :spotify_id, :fav_track, :top_tracks, :top_artists, :genres])
    |> validate_required([:name, :spotify_id])
  end
end
