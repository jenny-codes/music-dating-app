defmodule Songmate.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :bio, :text
      add :avatar, :string
      add :username, :string
      add :preferences_updated_at, :naive_datetime

      timestamps()
    end
  end
end
