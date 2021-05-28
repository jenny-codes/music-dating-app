defmodule Songmate.Community.Connection do
  use Ecto.Schema
  import Ecto.Changeset

  alias Songmate.Accounts.User
  alias Songmate.Community.UserConnection

  schema "connections" do
    field(:score, :integer)
    field(:shared_preferences, :map)

    many_to_many(:users, User,
      join_through: UserConnection,
      join_keys: [connection_id: :id, user_id: :id],
      on_replace: :delete
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
