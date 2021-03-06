defmodule Songmate.MusicServiceArtistTest do
  use Songmate.DataCase, async: true
  import Songmate.CustomAssertions
  import Songmate.MusicFactory

  alias Songmate.MusicService
  alias Songmate.Music.{Artist, Genre}

  def valid_artist_attrs do
    %{
      name: "9m88",
      popularity: 53,
      spotify_id: "4PjY2961rc0MHE9zHYWEnH"
    }
  end

  describe "batch_create_artists/2" do
    test "returns a list of Artist records for every input item" do
      existing_attrs = valid_artist_attrs()
      MusicService.create_artist(existing_attrs)
      new_attrs = %{name: "to be inserted", spotify_id: "dont really care"}

      result = MusicService.batch_create_artists([existing_attrs, new_attrs], order: true)

      assert [%Artist{}, %Artist{}] = result
    end

    test "when input is empty, returns empty" do
      assert Enum.empty?(MusicService.batch_create_artists([], order: true))
    end

    test "when order: true return the records in the same order as input" do
      attrs1 = %{name: "name1", spotify_id: "1"}
      attrs2 = %{name: "name2", spotify_id: "2"}
      attrs3 = %{name: "name3", spotify_id: "3"}

      first_input = [attrs1, attrs2, attrs3]
      first_result = MusicService.batch_create_artists(first_input, order: true)
      assert_same_list_by(:spotify_id, first_input, first_result)

      second_input = [attrs2, attrs1, attrs3]
      second_result = MusicService.batch_create_artists(second_input, order: true)
      assert_same_list_by(:spotify_id, second_input, second_result)

      third_input = [attrs3, attrs2, attrs1]
      third_result = MusicService.batch_create_artists(third_input, order: true)
      assert_same_list_by(:spotify_id, third_input, third_result)
    end
  end

  describe "artists" do
    @update_attrs %{
      name: "Updated 9m88",
      popularity: 100,
      spotify_id: "4PjY2961rc0MHE9zHYWEnH"
    }

    @invalid_attrs %{name: nil, spotify_id: nil}

    test "create_artist/1 with valid data creates a artist" do
      assert {:ok, %Artist{} = artist} = MusicService.create_artist(valid_artist_attrs())
      assert artist.name == "9m88"
      assert artist.popularity == 53
      assert artist.spotify_id == "4PjY2961rc0MHE9zHYWEnH"
    end

    test "create_artist/1 creates associated genres" do
      artist =
        create_artist(%{
          genres: [
            %{name: "Taiwanese Pop"}
          ]
        })

      artist = Repo.preload(artist, :genres)

      [genre] = artist.genres
      assert genre.name == "Taiwanese Pop"
    end

    test "create_artist/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = MusicService.create_artist(@invalid_attrs)
    end

    test "update_artist/2 with valid data updates the artist" do
      artist = create_artist()
      assert {:ok, %Artist{} = artist} = MusicService.update_artist(artist, @update_attrs)
      assert artist.name == "Updated 9m88"
      assert artist.popularity == 100
      assert artist.spotify_id == "4PjY2961rc0MHE9zHYWEnH"
    end

    test "update_artist/2 updates the associated genres" do
      artist =
        create_artist(%{
          genres: [
            %{name: "Taiwanese Pop"}
          ]
        })

      {:ok, updated_artist} = MusicService.update_artist(artist, %{genres: [%{name: "Jazz"}]})

      [genre] = updated_artist.genres
      assert genre.name == "Jazz"
      assert Repo.get_by(Genre, name: "Taiwanese Pop")
    end

    test "update_artist/2 with invalid data returns error changeset" do
      artist = create_artist()
      assert {:error, %Ecto.Changeset{}} = MusicService.update_artist(artist, @invalid_attrs)
    end
  end
end
