defmodule Songmate.MusicProfileTest do
  use Songmate.DataCase

  alias Songmate.MusicProfile

  describe "music_profiles" do
    alias Songmate.MusicProfile.User

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> MusicProfile.create_user()

      user
    end

    test "list_music_profiles/0 returns all music_profiles" do
      user = user_fixture()
      assert MusicProfile.list_music_profiles() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert MusicProfile.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = MusicProfile.create_user(@valid_attrs)
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = MusicProfile.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = MusicProfile.update_user(user, @update_attrs)
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = MusicProfile.update_user(user, @invalid_attrs)
      assert user == MusicProfile.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = MusicProfile.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> MusicProfile.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = MusicProfile.change_user(user)
    end
  end

  describe "artist_preferences" do
    alias Songmate.MusicProfile.ArtistPreference

    @valid_attrs %{rank: 42}
    @update_attrs %{rank: 43}
    @invalid_attrs %{rank: nil}

    def artist_preference_fixture(attrs \\ %{}) do
      {:ok, artist_preference} =
        attrs
        |> Enum.into(@valid_attrs)
        |> MusicProfile.create_artist_preference()

      artist_preference
    end

    test "list_artist_preferences/0 returns all artist_preferences" do
      artist_preference = artist_preference_fixture()
      assert MusicProfile.list_artist_preferences() == [artist_preference]
    end

    test "get_artist_preference!/1 returns the artist_preference with given id" do
      artist_preference = artist_preference_fixture()
      assert MusicProfile.get_artist_preference!(artist_preference.id) == artist_preference
    end

    test "create_artist_preference/1 with valid data creates a artist_preference" do
      assert {:ok, %ArtistPreference{} = artist_preference} = MusicProfile.create_artist_preference(@valid_attrs)
      assert artist_preference.rank == 42
    end

    test "create_artist_preference/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = MusicProfile.create_artist_preference(@invalid_attrs)
    end

    test "update_artist_preference/2 with valid data updates the artist_preference" do
      artist_preference = artist_preference_fixture()
      assert {:ok, %ArtistPreference{} = artist_preference} = MusicProfile.update_artist_preference(artist_preference, @update_attrs)
      assert artist_preference.rank == 43
    end

    test "update_artist_preference/2 with invalid data returns error changeset" do
      artist_preference = artist_preference_fixture()
      assert {:error, %Ecto.Changeset{}} = MusicProfile.update_artist_preference(artist_preference, @invalid_attrs)
      assert artist_preference == MusicProfile.get_artist_preference!(artist_preference.id)
    end

    test "delete_artist_preference/1 deletes the artist_preference" do
      artist_preference = artist_preference_fixture()
      assert {:ok, %ArtistPreference{}} = MusicProfile.delete_artist_preference(artist_preference)
      assert_raise Ecto.NoResultsError, fn -> MusicProfile.get_artist_preference!(artist_preference.id) end
    end

    test "change_artist_preference/1 returns a artist_preference changeset" do
      artist_preference = artist_preference_fixture()
      assert %Ecto.Changeset{} = MusicProfile.change_artist_preference(artist_preference)
    end
  end

  describe "track_preferences" do
    alias Songmate.MusicProfile.TrackPreference

    @valid_attrs %{rank: 42}
    @update_attrs %{rank: 43}
    @invalid_attrs %{rank: nil}

    def track_preference_fixture(attrs \\ %{}) do
      {:ok, track_preference} =
        attrs
        |> Enum.into(@valid_attrs)
        |> MusicProfile.create_track_preference()

      track_preference
    end

    test "list_track_preferences/0 returns all track_preferences" do
      track_preference = track_preference_fixture()
      assert MusicProfile.list_track_preferences() == [track_preference]
    end

    test "get_track_preference!/1 returns the track_preference with given id" do
      track_preference = track_preference_fixture()
      assert MusicProfile.get_track_preference!(track_preference.id) == track_preference
    end

    test "create_track_preference/1 with valid data creates a track_preference" do
      assert {:ok, %TrackPreference{} = track_preference} = MusicProfile.create_track_preference(@valid_attrs)
      assert track_preference.rank == 42
    end

    test "create_track_preference/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = MusicProfile.create_track_preference(@invalid_attrs)
    end

    test "update_track_preference/2 with valid data updates the track_preference" do
      track_preference = track_preference_fixture()
      assert {:ok, %TrackPreference{} = track_preference} = MusicProfile.update_track_preference(track_preference, @update_attrs)
      assert track_preference.rank == 43
    end

    test "update_track_preference/2 with invalid data returns error changeset" do
      track_preference = track_preference_fixture()
      assert {:error, %Ecto.Changeset{}} = MusicProfile.update_track_preference(track_preference, @invalid_attrs)
      assert track_preference == MusicProfile.get_track_preference!(track_preference.id)
    end

    test "delete_track_preference/1 deletes the track_preference" do
      track_preference = track_preference_fixture()
      assert {:ok, %TrackPreference{}} = MusicProfile.delete_track_preference(track_preference)
      assert_raise Ecto.NoResultsError, fn -> MusicProfile.get_track_preference!(track_preference.id) end
    end

    test "change_track_preference/1 returns a track_preference changeset" do
      track_preference = track_preference_fixture()
      assert %Ecto.Changeset{} = MusicProfile.change_track_preference(track_preference)
    end
  end

  describe "genre_preferences" do
    alias Songmate.MusicProfile.GenrePreference

    @valid_attrs %{rank: 42}
    @update_attrs %{rank: 43}
    @invalid_attrs %{rank: nil}

    def genre_preference_fixture(attrs \\ %{}) do
      {:ok, genre_preference} =
        attrs
        |> Enum.into(@valid_attrs)
        |> MusicProfile.create_genre_preference()

      genre_preference
    end

    test "list_genre_preferences/0 returns all genre_preferences" do
      genre_preference = genre_preference_fixture()
      assert MusicProfile.list_genre_preferences() == [genre_preference]
    end

    test "get_genre_preference!/1 returns the genre_preference with given id" do
      genre_preference = genre_preference_fixture()
      assert MusicProfile.get_genre_preference!(genre_preference.id) == genre_preference
    end

    test "create_genre_preference/1 with valid data creates a genre_preference" do
      assert {:ok, %GenrePreference{} = genre_preference} = MusicProfile.create_genre_preference(@valid_attrs)
      assert genre_preference.rank == 42
    end

    test "create_genre_preference/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = MusicProfile.create_genre_preference(@invalid_attrs)
    end

    test "update_genre_preference/2 with valid data updates the genre_preference" do
      genre_preference = genre_preference_fixture()
      assert {:ok, %GenrePreference{} = genre_preference} = MusicProfile.update_genre_preference(genre_preference, @update_attrs)
      assert genre_preference.rank == 43
    end

    test "update_genre_preference/2 with invalid data returns error changeset" do
      genre_preference = genre_preference_fixture()
      assert {:error, %Ecto.Changeset{}} = MusicProfile.update_genre_preference(genre_preference, @invalid_attrs)
      assert genre_preference == MusicProfile.get_genre_preference!(genre_preference.id)
    end

    test "delete_genre_preference/1 deletes the genre_preference" do
      genre_preference = genre_preference_fixture()
      assert {:ok, %GenrePreference{}} = MusicProfile.delete_genre_preference(genre_preference)
      assert_raise Ecto.NoResultsError, fn -> MusicProfile.get_genre_preference!(genre_preference.id) end
    end

    test "change_genre_preference/1 returns a genre_preference changeset" do
      genre_preference = genre_preference_fixture()
      assert %Ecto.Changeset{} = MusicProfile.change_genre_preference(genre_preference)
    end
  end
end
