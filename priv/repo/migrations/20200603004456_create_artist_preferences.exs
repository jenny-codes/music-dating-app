defmodule Songmate.Repo.Migrations.CreateArtistPreferences do
  use Ecto.Migration

  def change do
    create table(:artist_preferences) do
      add :rank, :integer
      add :user_id, references(:users, on_delete: :delete_all, null: false)
      add :artist_id, references(:artists, on_delete: :delete_all, null: false)

      timestamps()
    end

    create unique_index(:artist_preferences, [:user_id, :artist_id])
  end
end
