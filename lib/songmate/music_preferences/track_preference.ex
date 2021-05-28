defmodule Songmate.MusicPreferences.TrackPreference do
  use Ecto.Schema
  import Ecto.Changeset

  alias Songmate.Accounts.User
  alias Songmate.Music.Track

  schema "track_preferences" do
    field(:rank, :integer)

    belongs_to(:user, User)
    belongs_to(:track, Track)

    timestamps()
  end

  @doc false
  def changeset(track_preference, attrs) do
    track_preference
    |> cast(attrs, [:rank])
    |> validate_required([:rank])
    |> unique_constraint([:user_id, :track_id])
    |> unique_constraint([:user_id, :rank])
  end
end
