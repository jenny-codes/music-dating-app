defmodule Songmate.Community.Connection do
  use Ecto.Schema
  import Ecto.Changeset

  alias Songmate.MusicProfile
  alias Songmate.Community.ConnectionMusicProfile

  schema "connections" do
    field(:score, :integer)
    field(:shared_preferences, :map)

    many_to_many(:music_profiles, MusicProfile.Profile,
      join_through: ConnectionMusicProfile,
      join_keys: [connection_id: :id, music_profile_id: :id],
      on_replace: :delete,
    )

    timestamps()
  end

  @doc false
  def changeset(connection, attrs) do
    connection
    |> cast(attrs, [:score, :shared_preferences])
    |> validate_required([:score])
  end
end
