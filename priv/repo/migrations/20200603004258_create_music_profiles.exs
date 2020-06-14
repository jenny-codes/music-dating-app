defmodule Songmate.Repo.Migrations.CreateMusicProfiles do
  use Ecto.Migration

  def change do
    create table(:music_profiles) do
      add(:user_id, references(:users, on_delete: :delete_all, null: false))

      timestamps()
    end

    create(unique_index(:music_profiles, [:user_id]))
  end
end
