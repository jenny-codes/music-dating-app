defmodule Songmate.CredentialRepoTest do
  use Songmate.DataCase, async: true

  alias Songmate.Repo
  alias Songmate.Accounts.{User, Credential}
  alias Songmate.Accounts.CredentialRepo

  describe "credentials" do
    @valid_attrs %{
      provider: :spotify,
      email: "hi@songmate.co",
      provider_uid: "songmate",
      user: %{name: "Hi Songmate"}
    }
    @update_attrs %{
      email: "updated@songmate.co",
      provider_uid: "songmate"
    }
    @invalid_attrs %{provider: nil, email: nil, provider_uid: nil}

    def credential_fixture(attrs \\ %{}) do
      {:ok, credential} =
        attrs
        |> Enum.into(@valid_attrs)
        |> CredentialRepo.create_credential()

      credential
    end

    test "create_credential/1 with valid data creates a credential" do
      assert {:ok, %Credential{} = credential} = CredentialRepo.create_credential(@valid_attrs)
      assert credential.provider == :spotify
      assert credential.email == "hi@songmate.co"
      assert credential.provider_uid == "songmate"
      assert credential.user.name == "Hi Songmate"
    end

    test "create_credential/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CredentialRepo.create_credential(@invalid_attrs)
    end

    test "update_credential/2 with valid data updates the credential" do
      credential = credential_fixture()

      assert {:ok, %Credential{} = credential} =
               CredentialRepo.update_credential(credential, @update_attrs)

      assert credential.email == "updated@songmate.co"
      assert credential.provider_uid == "songmate"
    end

    test "update_credential/2 with invalid data returns error changeset" do
      credential = credential_fixture()

      assert {:error, %Ecto.Changeset{}} =
               CredentialRepo.update_credential(credential, @invalid_attrs)

      assert credential == Repo.get!(Credential, credential.id) |> Repo.preload(:user)
    end

    test "delete_credential/1 deletes the credential" do
      credential = credential_fixture()
      assert {:ok, %Credential{}} = CredentialRepo.delete_credential(credential)
      assert_raise Ecto.NoResultsError, fn -> Repo.get!(Credential, credential.id) end
    end

    test "delete_credential/1 does not delete the user" do
      credential = credential_fixture() |> Repo.preload(:user)
      user = credential.user

      assert {:ok, %Credential{}} = CredentialRepo.delete_credential(credential)
      assert user.id == Repo.get!(User, user.id).id
    end
  end
end
