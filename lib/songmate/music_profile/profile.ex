defmodule Songmate.MusicProfile.Profile do
  use Ecto.Schema
  import Ecto.Changeset

  alias Songmate.Accounts
  alias Songmate.MusicProfile.{ArtistPreference, TrackPreference, GenrePreference}

  schema "music_profiles" do
    belongs_to(:user, Accounts.User)
    has_many(:artist_preferences, ArtistPreference, foreign_key: :music_profile_id)
    has_many(:track_preferences, TrackPreference, foreign_key: :music_profile_id)
    has_many(:genre_preferences, GenrePreference, foreign_key: :music_profile_id)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [])
#    |> validate_required([:user])
    |> unique_constraint(:user_id)
  end
end
