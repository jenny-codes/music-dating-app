defmodule Songmate.MusicProfile.Profile do
  use Ecto.Schema
  import Ecto.Changeset

  alias Songmate.Accounts.User
  alias Songmate.Music.{Artist, Track, Genre}
  alias Songmate.MusicProfile.{ArtistPreference, TrackPreference, GenrePreference}

  schema "music_profiles" do
    belongs_to(:user, User)
    has_many(:artist_preferences, ArtistPreference, foreign_key: :music_profile_id)
    has_many(:track_preferences, TrackPreference, foreign_key: :music_profile_id)
    has_many(:genre_preferences, GenrePreference, foreign_key: :music_profile_id)

    many_to_many(
      :liked_artists,
      Artist,
      join_through: "artist_preferences",
      join_keys: [
        music_profile_id: :id,
        artist_id: :id
      ]
    )

    many_to_many(
      :liked_tracks,
      Track,
      join_through: "track_preferences",
      join_keys: [
        music_profile_id: :id,
        track_id: :id
      ]
    )

    many_to_many(
      :liked_genres,
      Genre,
      join_through: "genre_preferences",
      join_keys: [
        music_profile_id: :id,
        genre_id: :id
      ]
    )

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [])
    |> unique_constraint(:user_id)
  end
end
