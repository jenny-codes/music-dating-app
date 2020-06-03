defmodule Songmate.Community.Connection do
  use Ecto.Schema
  import Ecto.Changeset

  alias Songmate.MusicProfile

  schema "connections" do
    field(:score, :integer)
    field(:shared_preferences, :map)
    field(:music_profile_id, :id)

    many_to_many(:music_profiles, MusicProfile.User,
      join_through: "connections_music_profiles",
      on_replace: :delete
    )

    timestamps()
  end

  @doc false
  def changeset(connection, attrs) do
    connection
    |> cast(attrs, [:score, :shared_preferences])
    |> validate_required([:score, :shared_preferences])
  end
end
