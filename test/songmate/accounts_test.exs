defmodule Songmate.AccountsTest do
  use Songmate.DataCase

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

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(valid_user_attrs())
        |> Accounts.create_user()

      Repo.preload(user, :credential)
    end

    test "list_users/0 returns all credentials" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "get_user_by_token/1 with existing token returns existing user" do
      user_fixture(
        credential: %{
          provider: :spotify,
          email: "hi@songmate.co",
          username: "hisongmate",
          token: "existing token"
        }
      )

      user = Accounts.get_user_by_token("existing token")

      assert length(Repo.all(Accounts.Credential)) == 1
      assert length(Repo.all(Accounts.User)) == 1
      assert user.credential.token == "existing token"
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(valid_user_attrs())
      assert user.bio == "Some nights I stay up cashing in my bad luck"
      assert user.name == "Bass Wannabe"
      assert user.avatar == "some-link-to-an-image"
      assert user.credential.username == "hisongmate"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()

      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.bio == "Some nights I call it a draw"
      assert user.name == "Alto Wannabe"
      assert user.avatar == "another-link-to-an-image"
      assert user.credential.username == "hisongmate"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "delete_user/1 deletes the user with their credential" do
      user = user_fixture()
      credential = user.credential

      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_credential!(credential.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "credentials" do
    @valid_attrs %{
      provider: :spotify,
      email: "hi@songmate.co",
      username: "songmate",
      expires_at: "2010-04-17T14:00:00Z",
      token: "sometoken",
      user: %{name: "Hi Songmate"}
    }
    @update_attrs %{
      email: "updated@songmate.co",
      expires_at: "2011-05-18T15:01:01Z",
      token: "yetanothertoken",
      username: "songmate"
    }
    @invalid_attrs %{provider: nil, email: nil, username: nil}

    def credential_fixture(attrs \\ %{}) do
      {:ok, credential} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_credential()

      Repo.preload(credential, :user)
    end

    test "list_credentials/0 returns all credentials" do
      credential = credential_fixture()
      assert Accounts.list_credentials() == [credential]
    end

    test "get_credential!/1 returns the credential with given id" do
      credential = credential_fixture()
      assert Accounts.get_credential!(credential.id) == credential
    end

    test "create_credential/1 with valid data creates a credential" do
      assert {:ok, %Credential{} = credential} = Accounts.create_credential(@valid_attrs)
      assert credential.provider == :spotify
      assert credential.email == "hi@songmate.co"
      assert credential.expires_at == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert credential.token == "sometoken"
      assert credential.username == "songmate"
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
      assert credential.expires_at == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert credential.token == "yetanothertoken"
      assert credential.username == "songmate"
    end

    test "update_credential/2 with invalid data returns error changeset" do
      credential = credential_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_credential(credential, @invalid_attrs)
      assert credential == Accounts.get_credential!(credential.id)
    end

    test "delete_credential/1 deletes the credential" do
      credential = credential_fixture()
      assert {:ok, %Credential{}} = Accounts.delete_credential(credential)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_credential!(credential.id) end
    end

    test "delete_credential/1 does not delete the user" do
      credential = credential_fixture()
      user = credential.user

      assert {:ok, %Credential{}} = Accounts.delete_credential(credential)
      assert user.id == Accounts.get_user!(user.id).id
    end

    test "change_credential/1 returns a credential changeset" do
      credential = credential_fixture()
      assert %Ecto.Changeset{} = Accounts.change_credential(credential)
    end
  end
end
