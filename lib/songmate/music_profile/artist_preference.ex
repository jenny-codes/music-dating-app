defmodule Songmate.MusicProfile.ArtistPreference do
  use Ecto.Schema
  import Ecto.Changeset

  alias Songmate.MusicProfile
  alias Songmate.Music

  schema "artist_preferences" do
    field(:rank, :integer)

    belongs_to(:music_profile, MusicProfile.User)
    belongs_to(:artist, Music.Artist)

    timestamps()
  end

  @doc false
  def changeset(artist_preference, attrs) do
    artist_preference
    |> cast(attrs, [:rank])
    |> validate_required([:rank])
  end
end
