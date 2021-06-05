defmodule Songmate.Repo.Migrations.CreateMusicPreferences do
  use Ecto.Migration

  def change do
    create table(:music_preferences) do
      add :rank, :integer
      add :type, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all, null: false)
      add :type_id, :integer
    end
  end
end
