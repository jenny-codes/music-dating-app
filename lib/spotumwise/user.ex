defmodule Spotumwise.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :bio, :string
    field :name, :string
    field :spotify_id, :string
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
    |> unique_constraint(:spotify_id)
  end
end
