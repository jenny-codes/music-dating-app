defmodule Songmate.Repo.Migrations.AddPreferencesUpdatedAtToUsers do
  use Ecto.Migration

  def change do
    alter table("users") do
      add :preferences_updated_at, :naive_datetime
    end
  end
end
