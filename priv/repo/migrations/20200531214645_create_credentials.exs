defmodule Songmate.Repo.Migrations.CreateCredentials do
  use Ecto.Migration

  def change do
    create table(:credentials) do
      add(:provider, :string, null: false)
      add(:email, :string, null: false)
      add(:provider_uid, :string)
      add(:user_id, references(:users, on_delete: :delete_all), null: false)

      timestamps()
    end

    create(unique_index(:credentials, [:provider, :provider_uid]))
    create(index(:credentials, [:user_id]))
  end
end
