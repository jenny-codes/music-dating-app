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
    |> cast(attrs, [:rank])
    |> validate_required([:rank])
    |> unique_constraint([:user_id, :artist_id])
    |> unique_constraint([:user_id, :rank])
  end
end
