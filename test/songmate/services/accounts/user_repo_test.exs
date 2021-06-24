defmodule Songmate.UserServiceTest do
  use Songmate.DataCase, async: true

  alias Songmate.Repo
  alias Songmate.Accounts.{User, Credential}
  alias Songmate.Accounts.UserService
  import Songmate.UserFactory

  describe "users" do
    @valid_user_attrs %{
      name: "Bass Wannabe",
      username: "hisongmate",
      bio: "Some nights I stay up cashing in my bad luck",
      avatar: "some-link-to-an-image",
      credential: %{
        provider: :spotify,
        email: "hi@songmate.co",
        provider_uid: "hisongmate"
      }
    }

    @update_attrs %{
      bio: "Some nights I call it a draw",
      name: "Alto Wannabe",
      avatar: "another-link-to-an-image"
    }
    @invalid_attrs %{name: nil}

    test "list_users/0 returns all users" do
      user = create_user()

      result = UserService.list_users()

      assert result == [user]
    end

    test "list_users/1 returns all users excluding user ids in :except flag" do
      user = create_user()

      result = UserService.list_users(except: [user.id])

      assert result == []
    end

    test "get_or_create_user/1 creates a user if credential is new" do
      {:ok, user} = UserService.get_or_create_user(@valid_user_attrs)

      assert %User{} = user
      assert user.bio == "Some nights I stay up cashing in my bad luck"
      assert user.name == "Bass Wannabe"
      assert user.avatar == "some-link-to-an-image"
      assert user.credential.provider_uid == "hisongmate"
    end

    test "get_or_create_user/1 returns existing user if credential matches" do
      UserService.get_or_create_user(@valid_user_attrs)
      UserService.get_or_create_user(@valid_user_attrs)

      assert Repo.aggregate(User, :count) == 1
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = UserService.create_user(@valid_user_attrs)
      assert user.bio == "Some nights I stay up cashing in my bad luck"
      assert user.name == "Bass Wannabe"
      assert user.avatar == "some-link-to-an-image"
      assert user.credential.provider_uid == "hisongmate"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserService.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user =
        create_user(%{
          credential: %{
            provider: :spotify,
            email: "hi@songmate.co",
            provider_uid: "hisongmate"
          }
        })
        |> Repo.preload(:credential)

      assert {:ok, %User{} = user} = UserService.update_user(user, @update_attrs)
      assert user.bio == "Some nights I call it a draw"
      assert user.name == "Alto Wannabe"
      assert user.avatar == "another-link-to-an-image"
      assert user.credential.provider_uid == "hisongmate"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = create_user()
      assert {:error, %Ecto.Changeset{}} = UserService.update_user(user, @invalid_attrs)
      assert user == Repo.get!(User, user.id)
    end

    test "delete_user/1 deletes the user" do
      user = create_user()
      assert {:ok, %User{}} = UserService.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Repo.get!(User, user.id) end
    end

    test "delete_user/1 deletes the user with their credential" do
      user =
        create_user(%{
          credential: %{
            provider: :spotify,
            email: "hi@songmate.co",
            provider_uid: "hisongmate"
          }
        })
        |> Repo.preload(:credential)

      credential = user.credential

      assert {:ok, %User{}} = UserService.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Repo.get!(Credential, credential.id) end
    end
  end
end
