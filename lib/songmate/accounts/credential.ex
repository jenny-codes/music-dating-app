defmodule Songmate.Accounts.Credential do
  use Ecto.Schema
  import Ecto.Changeset

  alias Songmate.Accounts.User

  schema "credentials" do
    field(:provider, CredentialProviderEnum)
    field(:provider_uid, :string)
    field(:email, :string)

    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def changeset(credential, attrs) do
    credential
    |> cast(attrs, [:provider, :email, :provider_uid])
    |> validate_required([:provider, :email, :provider_uid])
    |> unique_constraint(:email)
    |> unique_constraint([:provider, :provider_uid])
  end
end
