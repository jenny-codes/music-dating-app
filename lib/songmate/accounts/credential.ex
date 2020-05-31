defmodule Songmate.Accounts.Credential do
  use Ecto.Schema
  import Ecto.Changeset

  schema "credentials" do
    field :provider, CredentialProviderEnum
    field :email, :string
    field :expires_at, :utc_datetime
    field :token, :string
    field :username, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(credential, attrs) do
    credential
    |> cast(attrs, [:provider, :email, :username, :token, :expires_at])
    |> validate_required([:provider, :email, :username])
    |> unique_constraint(:email)
    |> unique_constraint(:username)
  end
end
