defmodule Songmate.MusicProfile.GenrePreference do
  use Ecto.Schema
  import Ecto.Changeset

  alias Songmate.Repo
  alias Songmate.MusicProfile.Profile
  alias Songmate.Music.Genre

  schema "genre_preferences" do
    field(:rank, :integer)

    belongs_to(:music_profile, Profile)
    belongs_to(:genre, Genre)

    timestamps()
  end

  @doc false
  def changeset(genre_preference, attrs) do
    genre_preference
    |> cast(attrs, [:rank])
    |> validate_required([:rank])
    |> unique_constraint([:music_profile_id, :genre_id])
    |> unique_constraint([:music_profile_id, :rank])
  end
end
