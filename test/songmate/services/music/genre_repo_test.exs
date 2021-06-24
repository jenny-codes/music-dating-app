defmodule Songmate.TrackServiceTest do
  use Songmate.DataCase, async: true
  import Songmate.CustomAssertions
  import Songmate.MusicFactory

  alias Songmate.Music.GenreService
  alias Songmate.Music.Genre

  def valid_genre_attrs do
    %{name: "Modern Rock"}
  end

  describe "batch_get_or_create_genres/2" do
    test "returns a list of Genre records for every input item" do
      existing_attrs = valid_genre_attrs()
      GenreService.create_genre(existing_attrs)
      new_attrs = %{name: "to be inserted"}

      result = GenreService.batch_get_or_create_genres([existing_attrs, new_attrs], order: true)

      assert [%Genre{}, %Genre{}] = result
    end

    test "when input is empty, returns empty" do
      assert Enum.empty?(GenreService.batch_get_or_create_genres([], order: true))
    end

    test "when order: true return the records in the same order as input" do
      attrs1 = %{name: "name1"}
      attrs2 = %{name: "name2"}
      attrs3 = %{name: "name3"}

      first_input = [attrs1, attrs2, attrs3]
      first_result = GenreService.batch_get_or_create_genres(first_input, order: true)
      assert_same_list_by(:name, first_input, first_result)

      second_input = [attrs2, attrs1, attrs3]
      second_result = GenreService.batch_get_or_create_genres(second_input, order: true)
      assert_same_list_by(:name, second_input, second_result)

      third_input = [attrs3, attrs2, attrs1]
      third_result = GenreService.batch_get_or_create_genres(third_input, order: true)
      assert_same_list_by(:name, third_input, third_result)
    end
  end

  describe "genres" do
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    test "create_genre/1 with valid data creates a genre" do
      assert {:ok, %Genre{} = genre} = GenreService.create_genre(valid_genre_attrs())
      assert genre.name == "Modern Rock"
    end

    test "create_genre/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = GenreService.create_genre(@invalid_attrs)
    end

    test "update_genre/2 with valid data updates the genre" do
      genre = create_genre()
      assert {:ok, %Genre{} = genre} = GenreService.update_genre(genre, @update_attrs)
      assert genre.name == "some updated name"
    end

    test "update_genre/2 with invalid data returns error changeset" do
      genre = create_genre()
      assert {:error, %Ecto.Changeset{}} = GenreService.update_genre(genre, @invalid_attrs)
    end
  end
end
