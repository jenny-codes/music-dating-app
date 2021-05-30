defmodule Songmate.MusicPreferences.ArtistPreference do
  use Ecto.Schema
  import Ecto.Changeset

  alias Songmate.Music.Artist
  alias Songmate.Accounts.User

  schema "artist_preferences" do
    field(:rank, :integer)

    belongs_to(:user, User)
    belongs_to(:artist, Artist)

    timestamps()
  end

  @doc false
  def changeset(artist_preference, attrs) do
    artist_preference
    |> cast(attrs, [:rank, :user_id, :artist_id])
    |> validate_required([:rank, :user_id, :artist_id])
    |> unique_constraint([:rank, :user_id, :artist_id])
  end
end
