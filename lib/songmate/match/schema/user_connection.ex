defmodule Songmate.Community.UserConnection do
  use Ecto.Schema
  import Ecto.Changeset

  alias Songmate.Community.Connection
  alias Songmate.Accounts.User

  schema "users_connections" do
    belongs_to(:connection, Connection)
    belongs_to(:users, User)

    timestamps()
  end

  @doc false
  def changeset(user_connection, attrs) do
    user_connection
    |> cast(attrs, [])
    |> validate_required([])
  end
end
