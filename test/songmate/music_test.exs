defmodule Songmate.MusicTest do
  use Songmate.DataCase, async: true
  import Songmate.CustomAssertions

  alias Songmate.Music
  alias Songmate.Music.{Artist, Track, Genre}

  describe "batch_get_or_create_artists/2" do
    test "returns a list of Artist records for every input item" do
      existing_attrs = valid_artist_attrs()
      Music.create_artist(existing_attrs)
      new_attrs = %{name: "to be inserted", spotify_id: "dont really care"}

      result = Music.batch_get_or_create_artists([existing_attrs, new_attrs], order: true)

      assert [%Artist{}, %Artist{}] = result
    end

    test "when input is empty, returns empty" do
      assert Enum.empty?(Music.batch_get_or_create_artists([], order: true))
    end

    test "when order: true return the records in the same order as input" do
      attrs1 = %{name: "name1", spotify_id: "1"}
      attrs2 = %{name: "name2", spotify_id: "2"}
      attrs3 = %{name: "name3", spotify_id: "3"}

      first_input = [attrs1, attrs2, attrs3]
      first_result = Music.batch_get_or_create_artists(first_input, order: true)
      assert_same_list_by(:spotify_id, first_input, first_result)

      second_input = [attrs2, attrs1, attrs3]
      second_result = Music.batch_get_or_create_artists(second_input, order: true)
      assert_same_list_by(:spotify_id, second_input, second_result)

      third_input = [attrs3, attrs2, attrs1]
      third_result = Music.batch_get_or_create_artists(third_input, order: true)
      assert_same_list_by(:spotify_id, third_input, third_result)
    end
  end

  describe "batch_get_or_create_tracks/2" do
    test "returns a list of Track records for every input item" do
      existing_attrs = valid_track_attrs()
      Music.create_track(existing_attrs)
      new_attrs = %{name: "to be inserted", spotify_id: "dont really care"}

      result = Music.batch_get_or_create_tracks([existing_attrs, new_attrs], order: true)

      assert [%Track{}, %Track{}] = result
    end

    test "when input is empty, returns empty" do
      assert Enum.empty?(Music.batch_get_or_create_tracks([], order: true))
    end

    test "when order: true return the records in the same order as input" do
      attrs1 = %{name: "name1", spotify_id: "1"}
      attrs2 = %{name: "name2", spotify_id: "2"}
      attrs3 = %{name: "name3", spotify_id: "3"}

      first_input = [attrs1, attrs2, attrs3]
      first_result = Music.batch_get_or_create_tracks(first_input, order: true)
      assert_same_list_by(:spotify_id, first_input, first_result)

      second_input = [attrs2, attrs1, attrs3]
      second_result = Music.batch_get_or_create_tracks(second_input, order: true)
      assert_same_list_by(:spotify_id, second_input, second_result)

      third_input = [attrs3, attrs2, attrs1]
      third_result = Music.batch_get_or_create_tracks(third_input, order: true)
      assert_same_list_by(:spotify_id, third_input, third_result)
    end
  end

  describe "batch_get_or_create_genres/2" do
    test "returns a list of Genre records for every input item" do
      existing_attrs = valid_genre_attrs()
      Music.create_genre(existing_attrs)
      new_attrs = %{name: "to be inserted"}

      result = Music.batch_get_or_create_genres([existing_attrs, new_attrs], order: true)

      assert [%Genre{}, %Genre{}] = result
    end

    test "when input is empty, returns empty" do
      assert Enum.empty?(Music.batch_get_or_create_genres([], order: true))
    end

    test "when order: true return the records in the same order as input" do
      attrs1 = %{name: "name1"}
      attrs2 = %{name: "name2"}
      attrs3 = %{name: "name3"}

      first_input = [attrs1, attrs2, attrs3]
      first_result = Music.batch_get_or_create_genres(first_input, order: true)
      assert_same_list_by(:name, first_input, first_result)

      second_input = [attrs2, attrs1, attrs3]
      second_result = Music.batch_get_or_create_genres(second_input, order: true)
      assert_same_list_by(:name, second_input, second_result)

      third_input = [attrs3, attrs2, attrs1]
      third_result = Music.batch_get_or_create_genres(third_input, order: true)
      assert_same_list_by(:name, third_input, third_result)
    end
  end

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

    test "create_track/1 with valid data creates a track" do
      assert {:ok, %Track{} = track} = Music.create_track(valid_track_attrs())
      assert track.isrc == "USMRG0467010"
      assert track.name == "Rebellion (Lies)"
      assert track.popularity == 65
      assert track.spotify_id == "0xOeB16JDbBJBJKSdHbElT"
    end

    test "create_track/1 creates associated artists" do
      track =
        track_fixture(%{
          artists: [
            %{name: "Arcade Fire", spotify_id: "3kjuyTCjPG1WMFCiyc5IuB"}
          ]
        })

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
        track_fixture(%{
          artists: [
            %{name: "Arcade Fire", spotify_id: "3kjuyTCjPG1WMFCiyc5IuB"}
          ]
        })

      assert {:ok, %Track{artists: [artist]}} =
               Music.update_track(
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
    end
  end

  describe "artists" do
    def artist_fixture(attrs \\ %{}) do
      {:ok, artist} =
        attrs
        |> Enum.into(valid_artist_attrs())
        |> Music.create_artist()

      artist
    end

    @update_attrs %{
      name: "Updated 9m88",
      popularity: 100,
      spotify_id: "4PjY2961rc0MHE9zHYWEnH"
    }
    @invalid_attrs %{name: nil, spotify_id: nil}

    test "create_artist/1 with valid data creates a artist" do
      assert {:ok, %Artist{} = artist} = Music.create_artist(valid_artist_attrs())
      assert artist.name == "9m88"
      assert artist.popularity == 53
      assert artist.spotify_id == "4PjY2961rc0MHE9zHYWEnH"
    end

    test "create_artist/1 creates associated genres" do
      artist =
        artist_fixture(%{
          genres: [
            %{name: "Taiwanese Pop"}
          ]
        })

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
        artist_fixture(%{
          genres: [
            %{name: "Taiwanese Pop"}
          ]
        })

      {:ok, updated_artist} = Music.update_artist(artist, %{genres: [%{name: "Jazz"}]})

      [genre] = updated_artist.genres
      assert genre.name == "Jazz"
      assert Repo.get_by(Genre, name: "Taiwanese Pop")
    end

    test "update_artist/2 with invalid data returns error changeset" do
      artist = artist_fixture()
      assert {:error, %Ecto.Changeset{}} = Music.update_artist(artist, @invalid_attrs)
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
    end
  end
end
