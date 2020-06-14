defmodule Songmate.Repo.Migrations.CreateCredentials do
  use Ecto.Migration

  def change do
    CredentialProviderEnum.create_type()

    create table(:credentials) do
      add(:provider, CredentialProviderEnum.type(), null: false)
      add(:email, :string, null: false)
      add(:username, :string)
      add(:token, :string)
      add(:expires_at, :utc_datetime)
      add(:user_id, references(:users, on_delete: :delete_all), null: false)

      timestamps()
    end

    create(unique_index(:credentials, [:email]))
    create(unique_index(:credentials, [:username]))
    create(index(:credentials, [:user_id]))
  end
end
