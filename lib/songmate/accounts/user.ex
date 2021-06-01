defmodule Songmate.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Songmate.Accounts.Credential
  alias Songmate.Music.{Artist, Track, Genre}
  alias Songmate.MusicPreferences.{ArtistPreference, TrackPreference, GenrePreference}

  schema "users" do
    field(:bio, :string)
    field(:name, :string)
    field(:avatar, :string)
    field(:username, :string)
    field(:preferences_updated_at, :naive_datetime)

    has_one(:credential, Credential)
    has_many(:artist_preferences, ArtistPreference, foreign_key: :user_id)
    has_many(:track_preferences, TrackPreference, foreign_key: :user_id)
    has_many(:genre_preferences, GenrePreference, foreign_key: :user_id)

    many_to_many(
      :liked_artists,
      Artist,
      join_through: "artist_preferences",
      join_keys: [
        user_id: :id,
        artist_id: :id
      ]
    )

    many_to_many(
      :liked_tracks,
      Track,
      join_through: "track_preferences",
      join_keys: [
        user_id: :id,
        track_id: :id
      ]
    )

    many_to_many(
      :liked_genres,
      Genre,
      join_through: "genre_preferences",
      join_keys: [
        user_id: :id,
        genre_id: :id
      ]
    )

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [
      :name,
      :bio,
      :avatar,
      :username,
      :preferences_updated_at
    ])
    |> validate_required([:name])
    |> unique_constraint(:username)
  end
end
