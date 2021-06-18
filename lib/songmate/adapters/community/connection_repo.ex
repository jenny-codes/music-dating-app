defmodule Songmate.Community.ConnectionRepo do
  import Ecto.Query, warn: false
  alias Songmate.Repo

  alias Songmate.Community.Connection
  alias Songmate.Accounts.User

  def list_connections do
    Repo.all(Connection)
  end

  def get_connection!(id), do: Repo.get!(Connection, id)

  def create_connection(attrs \\ %{}) do
    %Connection{}
    |> Connection.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:users, with: &User.changeset/2)
    |> Repo.insert()
  end

  def update_connection(%Connection{} = connection, attrs) do
    connection
    |> Connection.changeset(attrs)
    |> Repo.update()
  end

  def delete_connection(%Connection{} = connection) do
    Repo.delete(connection)
  end

  def change_connection(%Connection{} = connection) do
    Connection.changeset(connection, %{})
  end
end
