defmodule Songmate.Repo.Migrations.CreateGenrePreferences do
  use Ecto.Migration

  def change do
    create table(:genre_preferences) do
      add :rank, :integer
      add :user_id, references(:users, on_delete: :delete_all, null: false)
      add :genre_id, references(:genres, on_delete: :delete_all, null: false)

      timestamps()
    end

    create unique_index(:genre_preferences, [:user_id, :genre_id, :rank])
  end
end
