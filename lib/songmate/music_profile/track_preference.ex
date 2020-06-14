defmodule Songmate.MusicProfile.TrackPreference do
  use Ecto.Schema
  import Ecto.Changeset

  alias Songmate.MusicProfile.Profile
  alias Songmate.Music.Track

  schema "track_preferences" do
    field(:rank, :integer)

    belongs_to(:music_profile, Profile)
    belongs_to(:track, Track)

    timestamps()
  end

  @doc false
  def changeset(track_preference, attrs) do
    track_preference
    |> cast(attrs, [:rank])
    |> validate_required([:rank])
    |> unique_constraint([:music_profile_id, :track_id])
    |> unique_constraint([:music_profile_id, :rank])
  end
end
