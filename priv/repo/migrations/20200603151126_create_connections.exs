defmodule Songmate.Repo.Migrations.CreateConnections do
  use Ecto.Migration

  def change do
    create table(:connections) do
      add(:score, :integer)
      add(:shared_preferences, :map)

      timestamps()
    end

    create table(:users_connections) do
      add(:connection_id, references(:connections, on_delete: :delete_all, null: false))
      add(:user_id, references(:users, on_delete: :delete_all, null: false))

      timestamps()
    end

    create(unique_index(:users_connections, [:connection_id, :user_id]))
  end
end
