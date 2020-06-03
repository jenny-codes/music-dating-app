defmodule Songmate.Repo.Migrations.CreateConnections do
  use Ecto.Migration

  def change do
    create table(:connections) do
      add :score, :integer
      add :shared_preferences, :map

      timestamps()
    end

    create table(:connections_music_profiles) do
      add :connection_id, references(:connections, on_delete: :delete_all), null: false)
      add :music_profile_id, references(:music_profiles, on_delete: :delete_all), null: false)

      timestamps()
    end

    create unique_index(:connections_music_profiles, [:connection_id, :music_profile_id])
  end
end
