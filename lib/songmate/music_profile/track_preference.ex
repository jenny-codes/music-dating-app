defmodule Songmate.MusicProfile.TrackPreference do
  use Ecto.Schema
  import Ecto.Changeset

  alias Songmate.MusicProfile
  alias Songmate.Music

  schema "track_preferences" do
    field(:rank, :integer)

    belongs_to(:music_profile, MusicProfile.Profile)
    belongs_to(:track, Music.Track)

    timestamps()
  end

  @doc false
  def changeset(track_preference, attrs) do
    track_preference
    |> cast(attrs, [:rank])
    |> validate_required([:rank])
  end
end
