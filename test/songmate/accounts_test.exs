defmodule Songmate.AccountsTest do
  use Songmate.DataCase, async: true

  alias Songmate.Repo
  alias Songmate.Accounts
  alias Songmate.Accounts.{User, Credential}

  describe "users" do
    @update_attrs %{
      bio: "Some nights I call it a draw",
      name: "Alto Wannabe",
      avatar: "another-link-to-an-image"
    }
    @invalid_attrs %{name: nil}

    test "get_or_create_user/1 creates a user if credential is new" do
      {:ok, user} = Accounts.get_or_create_user(valid_user_attrs())

      assert %User{} = user
      assert user.bio == "Some nights I stay up cashing in my bad luck"
      assert user.name == "Bass Wannabe"
      assert user.avatar == "some-link-to-an-image"
      assert user.credential.provider_uid == "hisongmate"
    end

    test "get_or_create_user/1 returns existing user if credential matches" do
      Accounts.get_or_create_user(valid_user_attrs())
      Accounts.get_or_create_user(valid_user_attrs())

      assert Repo.aggregate(User, :count) == 1
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(valid_user_attrs())
      assert user.bio == "Some nights I stay up cashing in my bad luck"
      assert user.name == "Bass Wannabe"
      assert user.avatar == "some-link-to-an-image"
      assert user.credential.provider_uid == "hisongmate"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture() |> Repo.preload(:credential)

      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.bio == "Some nights I call it a draw"
      assert user.name == "Alto Wannabe"
      assert user.avatar == "another-link-to-an-image"
      assert user.credential.provider_uid == "hisongmate"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Repo.get!(User, user.id) |> Repo.preload(:credential)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Repo.get!(User, user.id) end
    end

    test "delete_user/1 deletes the user with their credential" do
      user = user_fixture() |> Repo.preload(:credential)

      credential = user.credential

      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Repo.get!(Credential, credential.id) end
    end
  end

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
        |> Accounts.create_credential()

      credential
    end

    test "create_credential/1 with valid data creates a credential" do
      assert {:ok, %Credential{} = credential} = Accounts.create_credential(@valid_attrs)
      assert credential.provider == :spotify
      assert credential.email == "hi@songmate.co"
      assert credential.provider_uid == "songmate"
      assert credential.user.name == "Hi Songmate"
    end

    test "create_credential/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_credential(@invalid_attrs)
    end

    test "update_credential/2 with valid data updates the credential" do
      credential = credential_fixture()

      assert {:ok, %Credential{} = credential} =
               Accounts.update_credential(credential, @update_attrs)

      assert credential.email == "updated@songmate.co"
      assert credential.provider_uid == "songmate"
    end

    test "update_credential/2 with invalid data returns error changeset" do
      credential = credential_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_credential(credential, @invalid_attrs)
      assert credential == Repo.get!(Credential, credential.id) |> Repo.preload(:user)
    end

    test "delete_credential/1 deletes the credential" do
      credential = credential_fixture()
      assert {:ok, %Credential{}} = Accounts.delete_credential(credential)
      assert_raise Ecto.NoResultsError, fn -> Repo.get!(Credential, credential.id) end
    end

    test "delete_credential/1 does not delete the user" do
      credential = credential_fixture() |> Repo.preload(:user)
      user = credential.user

      assert {:ok, %Credential{}} = Accounts.delete_credential(credential)
      assert user.id == Repo.get!(User, user.id).id
    end
  end
end
