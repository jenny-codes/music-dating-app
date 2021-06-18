defmodule Songmate.AccountsTest do
  use Songmate.DataCase, async: true

  alias Songmate.Repo
  alias Songmate.Accounts.{User, Credential, MusicPreference}
  alias Songmate.Accounts.{UserRepo, CredentialRepo, MusicPreferenceRepo}

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

  describe "list_music_preferences/1" do
    test "returns a list of MusicPreference by user ids" do
      user = user_fixture()

      valid_input = [
        %{
          user_id: user.id,
          type: :artist,
          type_id: 3,
          rank: 2
        }
      ]

      MusicPreferenceRepo.batch_upsert_music_preferences_for_user(valid_input, user.id)

      result = MusicPreferenceRepo.list_music_preferences(user_ids: [user.id])

      assert Enum.count(result) == 1
      assert List.first(result).user_id == user.id
    end
  end

  describe "batch_upsert_music_preferences_for_user/2" do
    test "batch insert records for user" do
      user = user_fixture()

      valid_input = [
        %{
          user_id: user.id,
          type: :artist,
          type_id: 3,
          rank: 2
        }
      ]

      MusicPreferenceRepo.batch_upsert_music_preferences_for_user(valid_input, user.id)

      assert Repo.get_by(MusicPreference, user_id: user.id, type: :artist, type_id: 3, rank: 2)
    end

    test "delete all previous records of the user first" do
      user = user_fixture()

      previous_record = [
        %{
          user_id: user.id,
          type: :artist,
          type_id: 3,
          rank: 2
        }
      ]

      new_record = [
        %{
          user_id: user.id,
          type: :artist,
          type_id: 33,
          rank: 22
        }
      ]

      MusicPreferenceRepo.batch_upsert_music_preferences_for_user(previous_record, user.id)
      MusicPreferenceRepo.batch_upsert_music_preferences_for_user(new_record, user.id)

      refute Repo.get_by(MusicPreference, user_id: user.id, type: :artist, type_id: 3, rank: 2)
    end

    test "do nothing if input list is empty or nil" do
      user = user_fixture()

      record = [
        %{
          user_id: user.id,
          type: :artist,
          type_id: 3,
          rank: 2
        }
      ]

      # Establishing record
      MusicPreferenceRepo.batch_upsert_music_preferences_for_user(record, user.id)

      # This shouldn't erase the existing record.
      MusicPreferenceRepo.batch_upsert_music_preferences_for_user([], user.id)

      assert Repo.get_by(MusicPreference, user_id: user.id, type: :artist, type_id: 3, rank: 2)
    end
  end

  describe "delete situation" do
    test "delete User deletes associated preferences" do
      user = user_fixture()

      record = [
        %{
          user_id: user.id,
          type: :artist,
          type_id: 3,
          rank: 2
        }
      ]

      MusicPreferenceRepo.batch_upsert_music_preferences_for_user(record, user.id)
      {:ok, _} = Repo.delete(user)

      refute Repo.exists?(from(pref in MusicPreference, where: pref.user_id == ^user.id))
    end

    test "delete preferences does not delete associated user" do
      user = user_fixture()

      record = [
        %{
          user_id: user.id,
          type: :artist,
          type_id: 3,
          rank: 2
        }
      ]

      MusicPreferenceRepo.batch_upsert_music_preferences_for_user(record, user.id)

      Repo.delete_all(MusicPreference)

      assert Repo.exists?(Songmate.Accounts.User)
    end
  end
end
