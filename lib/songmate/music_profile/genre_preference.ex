defmodule Songmate.MusicProfile.GenrePreference do
  use Ecto.Schema
  import Ecto.Changeset

  alias Songmate.MusicProfile
  alias Songmate.Music

  schema "genre_preferences" do
    field(:rank, :integer)

    belongs_to(:music_profile, MusicProfile.Profile)
    belongs_to(:genre, Music.Genre)

    timestamps()
  end

  @doc false
  def changeset(genre_preference, attrs) do
    genre_preference
    |> cast(attrs, [:rank])
    |> validate_required([:rank])
  end
end
