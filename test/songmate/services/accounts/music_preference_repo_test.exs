defmodule Songamte.MusicPreferenceServiceTest do
  use Songmate.DataCase, async: true

  alias Songmate.Repo
  alias Songmate.Accounts.MusicPreference
  alias Songmate.Accounts.MusicPreferenceService

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

      MusicPreferenceService.batch_upsert_music_preferences_for_user(valid_input, user.id)

      result = MusicPreferenceService.list_music_preferences(user_ids: [user.id])

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

      MusicPreferenceService.batch_upsert_music_preferences_for_user(valid_input, user.id)

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

      MusicPreferenceService.batch_upsert_music_preferences_for_user(previous_record, user.id)
      MusicPreferenceService.batch_upsert_music_preferences_for_user(new_record, user.id)

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
      MusicPreferenceService.batch_upsert_music_preferences_for_user(record, user.id)

      # This shouldn't erase the existing record.
      MusicPreferenceService.batch_upsert_music_preferences_for_user([], user.id)

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

      MusicPreferenceService.batch_upsert_music_preferences_for_user(record, user.id)
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

      MusicPreferenceService.batch_upsert_music_preferences_for_user(record, user.id)

      Repo.delete_all(MusicPreference)

      assert Repo.exists?(Songmate.Accounts.User)
    end
  end
end
