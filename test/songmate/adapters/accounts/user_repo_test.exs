defmodule Songmate.UserRepoTest do
  use Songmate.DataCase, async: true

  alias Songmate.Repo
  alias Songmate.Accounts.{User, Credential}
  alias Songmate.Accounts.UserRepo

  describe "users" do
    @update_attrs %{
      bio: "Some nights I call it a draw",
      name: "Alto Wannabe",
      avatar: "another-link-to-an-image"
    }
    @invalid_attrs %{name: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()

      result = UserRepo.list_users() |> Repo.preload(:credential)

      assert result == [user]
    end

    test "list_users/1 returns all users excluding user ids in :except flag" do
      user = user_fixture()

      result = UserRepo.list_users(except: [user.id])

      assert result == []
    end

    test "get_or_create_user/1 creates a user if credential is new" do
      {:ok, user} = UserRepo.get_or_create_user(valid_user_attrs())

      assert %User{} = user
      assert user.bio == "Some nights I stay up cashing in my bad luck"
      assert user.name == "Bass Wannabe"
      assert user.avatar == "some-link-to-an-image"
      assert user.credential.provider_uid == "hisongmate"
    end

    test "get_or_create_user/1 returns existing user if credential matches" do
      UserRepo.get_or_create_user(valid_user_attrs())
      UserRepo.get_or_create_user(valid_user_attrs())

      assert Repo.aggregate(User, :count) == 1
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = UserRepo.create_user(valid_user_attrs())
      assert user.bio == "Some nights I stay up cashing in my bad luck"
      assert user.name == "Bass Wannabe"
      assert user.avatar == "some-link-to-an-image"
      assert user.credential.provider_uid == "hisongmate"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserRepo.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture() |> Repo.preload(:credential)

      assert {:ok, %User{} = user} = UserRepo.update_user(user, @update_attrs)
      assert user.bio == "Some nights I call it a draw"
      assert user.name == "Alto Wannabe"
      assert user.avatar == "another-link-to-an-image"
      assert user.credential.provider_uid == "hisongmate"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = UserRepo.update_user(user, @invalid_attrs)
      assert user == Repo.get!(User, user.id) |> Repo.preload(:credential)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = UserRepo.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Repo.get!(User, user.id) end
    end

    test "delete_user/1 deletes the user with their credential" do
      user = user_fixture() |> Repo.preload(:credential)

      credential = user.credential

      assert {:ok, %User{}} = UserRepo.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Repo.get!(Credential, credential.id) end
    end
  end
end
