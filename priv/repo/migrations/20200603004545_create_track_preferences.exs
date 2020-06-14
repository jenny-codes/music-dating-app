defmodule Songmate.Repo.Migrations.CreateTrackPreferences do
  use Ecto.Migration

  def change do
    create table(:track_preferences) do
      add :rank, :integer
      add :music_profile_id, references(:music_profiles, on_delete: :delete_all, null: false)
      add :track_id, references(:tracks, on_delete: :delete_all, null: false)

      timestamps()
    end

    create unique_index(:track_preferences, [:music_profile_id, :track_id])
  end
end
