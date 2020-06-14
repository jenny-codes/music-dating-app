defmodule Songmate.MusicProfile.ArtistPreference do
  use Ecto.Schema
  import Ecto.Changeset

  alias Songmate.Repo
  alias Songmate.Music.Artist
  alias Songmate.MusicProfile.Profile

  schema "artist_preferences" do
    field(:rank, :integer)

    belongs_to(:music_profile, Profile)
    belongs_to(:artist, Artist)

    timestamps()
  end

  @doc false
  def changeset(artist_preference, attrs) do
    artist_preference
    |> cast(attrs, [:rank])
    |> validate_required([:rank])
    |> unique_constraint([:music_profile_id, :artist_id])
    |> unique_constraint([:music_profile_id, :rank])
  end
end
