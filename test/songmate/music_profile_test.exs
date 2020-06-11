defmodule Songmate.MusicProfileTest do
  use Songmate.DataCase

  alias Songmate.Accounts
  alias Songmate.MusicProfile
  alias Songmate.MusicProfile.Profile

  describe "music_profiles" do
    @valid_account_user_attrs %{user: %{name: "Spotify Rocks"}}

    @valid_artist_attrs %{}

    def profile_fixture(attrs \\ %{}) do
      {:ok, profile} = MusicProfile.create_profile(attrs)

      profile
    end

    test "list_music_profiles/0 returns all music_profiles" do
      profile = profile_fixture()
      assert MusicProfile.list_music_profiles() == [profile]
    end

    test "get_profile!/1 returns the profile with given id" do
      profile = profile_fixture()
      assert MusicProfile.get_profile!(profile.id) == profile
    end

    test "create_profile/1 with valid profile association creates a profile" do
      {:ok, %Profile{} = profile} = MusicProfile.create_profile(@valid_account_user_attrs)

      assert profile.user.id
      assert profile.user.name == "Spotify Rocks"
    end

    test "create_profile/1 with artists preference associations creates associations" do
      artists_pref = %{
        rank: 1,
        artist: @valid_artist_attrs
      }

      {:ok, %Profile = profile} = MusicProfile.create_profile()

    end

    test "delete_profile/1 deletes the user profile" do
      profile = profile_fixture()
      assert {:ok, %Profile{}} = MusicProfile.delete_profile(profile)
      assert_raise Ecto.NoResultsError, fn -> MusicProfile.get_profile!(profile.id) end
    end

    test "delete Account.User deletes associated profile and preferences" do

    end

    test "change_profile/1 returns a profile changeset" do
      profile = profile_fixture()
      assert %Ecto.Changeset{} = MusicProfile.change_profile(profile)
    end
  end
end
