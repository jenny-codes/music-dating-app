defmodule Songmate.Community.ConnectionMusicProfile do
  use Ecto.Schema
  import Ecto.Changeset

  alias Songmate.Community.Connection
  alias Songmate.MusicProfile.Profile

  schema "connections_music_profiles" do
    belongs_to :connection, Connection
    belongs_to :music_profile, Profile

    timestamps()
  end

  @doc false
  def changeset(connection_music_profile, attrs) do
    connection_music_profile
    |> cast(attrs, [])
    |> validate_required([])
  end
end
