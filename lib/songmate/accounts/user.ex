defmodule Songmate.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Songmate.Accounts.Credential
  alias Songmate.Accounts.MusicPreference

  schema "users" do
    field(:bio, :string)
    field(:name, :string)
    field(:avatar, :string)
    field(:username, :string)
    field(:preferences_updated_at, :naive_datetime)

    has_one(:credential, Credential)
    has_many(:music_preferences, MusicPreference, foreign_key: :user_id)

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
