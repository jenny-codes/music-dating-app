defmodule Songmate.MusicTest do
  use Songmate.DataCase

  alias Songmate.Music
  alias Songmate.Music.{Artist, Track, Genre}

  describe "tracks" do
    @update_attrs %{
      name: "updated Rebellion",
      popularity: 90
    }
    @invalid_attrs %{name: nil, potify_id: nil}

    def track_fixture(attrs \\ %{}) do
      {:ok, track} =
        attrs
        |> Enum.into(valid_track_attrs())
        |> Music.create_track()
      track
    end

    test "list_tracks/0 returns all tracks" do
      track = track_fixture()
      assert Music.list_tracks() == [track]
    end

    test "get_track!/1 returns the track with given id" do
      track = track_fixture()
      assert Music.get_track!(track.id) == track
    end

    test "create_track/1 with valid data creates a track" do
      assert {:ok, %Track{} = track} = Music.create_track(valid_track_attrs())
      assert track.isrc == "USMRG0467010"
      assert track.name == "Rebellion (Lies)"
      assert track.popularity == 65
      assert track.spotify_id == "0xOeB16JDbBJBJKSdHbElT"
    end

    test "create_track/1 creates associated artists" do
      track =
        track_fixture(
          %{
            artists: [
              %{name: "Arcade Fire", spotify_id: "3kjuyTCjPG1WMFCiyc5IuB"}
            ]
          }
        )

      track = Repo.preload(track, :artists)

      [artist] = track.artists
      assert artist.id
      assert artist.name == "Arcade Fire"
      assert artist.spotify_id == "3kjuyTCjPG1WMFCiyc5IuB"
    end

    test "create_track/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Music.create_track(@invalid_attrs)
    end

    test "update_track/2 with valid data updates the track" do
      track = track_fixture()
      assert {:ok, %Track{} = track} = Music.update_track(track, @update_attrs)
      assert track.isrc == "USMRG0467010"
      assert track.name == "updated Rebellion"
      assert track.popularity == 90
      assert track.spotify_id == "0xOeB16JDbBJBJKSdHbElT"
    end

    test "update_track/2 with artists updates the association" do
      track =
        track_fixture(
          %{
            artists: [
              %{name: "Arcade Fire", spotify_id: "3kjuyTCjPG1WMFCiyc5IuB"}
            ]
          }
        )
      assert {:ok, %Track{artists: [artist]}} = Music.update_track(
               track,
               %{
                 artists: [
                   %{name: "Updated Artist", spotify_id: "updated-spotify-id"}
                 ]
               }
             )
      assert artist.id
      assert artist.name == "Updated Artist"
      assert artist.spotify_id == "updated-spotify-id"
    end

    test "update_track/2 with invalid data returns error changeset" do
      track = track_fixture()
      assert {:error, %Ecto.Changeset{}} = Music.update_track(track, @invalid_attrs)
      assert track == Music.get_track!(track.id)
    end

    test "delete_track/1 deletes the track" do
      track = track_fixture()
      assert {:ok, %Track{}} = Music.delete_track(track)
      assert_raise Ecto.NoResultsError, fn -> Music.get_track!(track.id) end
    end

    test "delete_track/1 does not delete associated artists" do
      track = track_fixture(
        %{
          artists: [
            %{name: "Arcade Fire", spotify_id: "3kjuyTCjPG1WMFCiyc5IuB"}
          ]
        }
      )
      artist = track.artists
               |> List.first
      Music.delete_track(track)

      assert Music.get_artist!(artist.id)
    end

    test "change_track/1 returns a track changeset" do
      track = track_fixture()
      assert %Ecto.Changeset{} = Music.change_track(track)
    end
  end

  describe "artists" do
    @update_attrs %{
      name: "Updated 9m88",
      popularity: 100,
      spotify_id: "4PjY2961rc0MHE9zHYWEnH"
    }
    @invalid_attrs %{name: nil, spotify_id: nil}

    def artist_fixture(attrs \\ %{}) do
      {:ok, artist} =
        attrs
        |> Enum.into(valid_artist_attrs())
        |> Music.create_artist()

      artist
    end

    test "list_artists/0 returns all artists" do
      artist = artist_fixture()
      assert Music.list_artists() == [artist]
    end

    test "get_artist!/1 returns the artist with given id" do
      artist = artist_fixture()
      assert Music.get_artist!(artist.id) == artist
    end

    test "create_artist/1 with valid data creates a artist" do
      assert {:ok, %Artist{} = artist} = Music.create_artist(valid_artist_attrs())
      assert artist.name == "9m88"
      assert artist.popularity == 53
      assert artist.spotify_id == "4PjY2961rc0MHE9zHYWEnH"
    end

    test "create_artist/1 creates associated genres" do
      artist =
        artist_fixture(
          %{
            genres: [
              %{name: "Taiwanese Pop"}
            ]
          }
        )

      artist = Repo.preload(artist, :genres)

      [genre] = artist.genres
      assert genre.name == "Taiwanese Pop"
    end

    test "create_artist/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Music.create_artist(@invalid_attrs)
    end

    test "update_artist/2 with valid data updates the artist" do
      artist = artist_fixture()
      assert {:ok, %Artist{} = artist} = Music.update_artist(artist, @update_attrs)
      assert artist.name == "Updated 9m88"
      assert artist.popularity == 100
      assert artist.spotify_id == "4PjY2961rc0MHE9zHYWEnH"
    end

    test "update_artist/2 updates the associated genres" do
      artist =
        artist_fixture(
          %{
            genres: [
              %{name: "Taiwanese Pop"}
            ]
          }
        )

      {:ok, updated_artist} = Music.update_artist(artist, %{genres: [%{name: "Jazz"}]})

      [genre] = updated_artist.genres
      assert genre.name == "Jazz"
      assert Repo.get_by(Genre, name: "Taiwanese Pop")
    end

    test "update_artist/2 with invalid data returns error changeset" do
      artist = artist_fixture()
      assert {:error, %Ecto.Changeset{}} = Music.update_artist(artist, @invalid_attrs)
      assert artist == Music.get_artist!(artist.id)
    end

    test "delete_artist/1 deletes the artist" do
      artist = artist_fixture()
      assert {:ok, %Artist{}} = Music.delete_artist(artist)
      assert_raise Ecto.NoResultsError, fn -> Music.get_artist!(artist.id) end
    end

    test "change_artist/1 returns a artist changeset" do
      artist = artist_fixture()
      assert %Ecto.Changeset{} = Music.change_artist(artist)
    end
  end

  describe "genres" do
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def genre_fixture(attrs \\ %{}) do
      {:ok, genre} =
        attrs
        |> Enum.into(valid_genre_attrs())
        |> Music.create_genre()

      genre
    end

    test "list_genres/0 returns all genres" do
      genre = genre_fixture()
      assert Music.list_genres() == [genre]
    end

    test "get_genre!/1 returns the genre with given id" do
      genre = genre_fixture()
      assert Music.get_genre!(genre.id) == genre
    end

    test "create_genre/1 with valid data creates a genre" do
      assert {:ok, %Genre{} = genre} = Music.create_genre(valid_genre_attrs())
      assert genre.name == "Modern Rock"
    end

    test "create_genre/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Music.create_genre(@invalid_attrs)
    end

    test "update_genre/2 with valid data updates the genre" do
      genre = genre_fixture()
      assert {:ok, %Genre{} = genre} = Music.update_genre(genre, @update_attrs)
      assert genre.name == "some updated name"
    end

    test "update_genre/2 with invalid data returns error changeset" do
      genre = genre_fixture()
      assert {:error, %Ecto.Changeset{}} = Music.update_genre(genre, @invalid_attrs)
      assert genre == Music.get_genre!(genre.id)
    end

    test "delete_genre/1 deletes the genre" do
      genre = genre_fixture()
      assert {:ok, %Genre{}} = Music.delete_genre(genre)
      assert_raise Ecto.NoResultsError, fn -> Music.get_genre!(genre.id) end
    end

    test "change_genre/1 returns a genre changeset" do
      genre = genre_fixture()
      assert %Ecto.Changeset{} = Music.change_genre(genre)
    end
  end
end
