defmodule Songmate.Accounts.CredentialRepo do
  alias Songmate.Repo
  alias Songmate.Accounts.{User, Credential}

  def create_credential(attrs \\ %{}) do
    %Credential{}
    |> Credential.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:user, with: &User.changeset/2)
    |> Repo.insert()
  end

  def update_credential(%Credential{} = credential, attrs) do
    credential
    |> Credential.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:user, with: &User.changeset/2)
    |> Repo.update()
  end

  def delete_credential(%Credential{} = credential) do
    Repo.delete(credential)
  end
end
