defmodule Songmate.Repo.Migrations.CreateTrackPreferences do
  use Ecto.Migration

  def change do
    create table(:track_preferences) do
      add :rank, :integer
      add :user_id, references(:users, on_delete: :delete_all, null: false)
      add :track_id, references(:tracks, on_delete: :delete_all, null: false)

      timestamps()
    end

    create unique_index(:track_preferences, [:user_id, :track_id, :rank])
  end
end
