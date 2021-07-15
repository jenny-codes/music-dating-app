defmodule Songmate.Accounts.MusicPreference do
  use Ecto.Schema
  import Ecto.Changeset

  alias Songmate.Accounts.User

  @music_types [:artist, :track, :genre]
  schema "music_preferences" do
    field(:type, Ecto.Enum, values: @music_types)
    field(:rank, :integer)
    field(:type_id, :integer)

    belongs_to(:user, User)
  end

  @doc false
  def changeset(artist_preference, attrs) do
    artist_preference
    |> cast(attrs, [:type, :rank, :user_id, :type_id])
    |> validate_required([:type, :user_id, :type_id])
  end
end
