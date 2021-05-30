defmodule Songmate.MusicPreferencesTest do
  use Songmate.DataCase

  alias Songmate.MusicPreferences
  alias Songmate.MusicPreferences.{ArtistPreference, TrackPreference, GenrePreference}

  def artist_fixure(attrs \\ %{}) do
    {:ok, artist} =
      attrs
      |> Enum.into(valid_artist_attrs())
      |> Songmate.Music.create_artist()

    artist
  end

  def track_fixure(attrs \\ %{}) do
    {:ok, track} =
      attrs
      |> Enum.into(valid_track_attrs())
      |> Songmate.Music.create_track()

    track
  end

  def genre_fixure(attrs \\ %{}) do
    {:ok, genre} =
      attrs
      |> Enum.into(valid_genre_attrs())
      |> Songmate.Music.create_genre()

    genre
  end

  describe "batch_create_artist_preferences/2" do
    test "creates preferences with artists and user" do
      user = user_fixture()
      artist = artist_fixure()

      MusicPreferences.batch_create_artist_preferences([artist], user)

      assert Repo.get_by(ArtistPreference, user_id: user.id, artist_id: artist.id)
    end

    test "creates preferences using original order as rank" do
      user = user_fixture()
      artist1 = artist_fixure(%{spotify_id: "123"})
      artist2 = artist_fixure(%{spotify_id: "456"})

      MusicPreferences.batch_create_artist_preferences([artist1, artist2], user)

      assert Repo.get_by(ArtistPreference,
               user_id: user.id,
               artist_id: artist1.id,
               rank: 1
             )

      assert Repo.get_by(ArtistPreference,
               user_id: user.id,
               artist_id: artist2.id,
               rank: 2
             )
    end
  end

  describe "batch_create_track_preferences/2" do
    test "creates preferences with tracks and user" do
      user = user_fixture()
      track = track_fixure()

      MusicPreferences.batch_create_track_preferences([track], user)

      assert Repo.get_by(TrackPreference, user_id: user.id, track_id: track.id)
    end

    test "creates preferences using original order as rank" do
      user = user_fixture()
      track1 = track_fixure(%{spotify_id: "123", isrc: "123"})
      track2 = track_fixure(%{spotify_id: "456", isrc: "456"})

      MusicPreferences.batch_create_track_preferences([track1, track2], user)

      assert Repo.get_by(TrackPreference,
               user_id: user.id,
               track_id: track1.id,
               rank: 1
             )

      assert Repo.get_by(TrackPreference,
               user_id: user.id,
               track_id: track2.id,
               rank: 2
             )
    end
  end

  describe "batch_create_genre_preferences/2" do
    test "creates preferences with genres and user" do
      user = user_fixture()
      genre = genre_fixure()

      MusicPreferences.batch_create_genre_preferences([genre], user)

      assert Repo.get_by(GenrePreference, user_id: user.id, genre_id: genre.id)
    end

    test "creates preferences using original order as rank" do
      user = user_fixture()
      genre1 = genre_fixure(%{name: "123"})
      genre2 = genre_fixure(%{name: "456"})

      MusicPreferences.batch_create_genre_preferences([genre1, genre2], user)

      assert Repo.get_by(GenrePreference,
               user_id: user.id,
               genre_id: genre1.id,
               rank: 1
             )

      assert Repo.get_by(GenrePreference,
               user_id: user.id,
               genre_id: genre2.id,
               rank: 2
             )
    end
  end

  describe "delete situation" do
    test "delete User deletes associated preferences" do
      user = user_fixture()
      artist = artist_fixure()
      MusicPreferences.batch_create_artist_preferences([artist], user)

      {:ok, _} = Repo.delete(user)

      refute Repo.exists?(from(pref in ArtistPreference, where: pref.user_id == ^user.id))
    end

    test "delete preferences does not delete associated user or music types" do
      user = user_fixture()
      artist = artist_fixure()
      MusicPreferences.batch_create_artist_preferences([artist], user)

      Repo.delete_all(ArtistPreference)

      assert Repo.exists?(Songmate.Accounts.User)
      assert Repo.exists?(Songmate.Music.Artist)
    end
  end
end
