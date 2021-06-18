defmodule Songmate.TrackRepoTest do
  use Songmate.DataCase, async: true
  import Songmate.CustomAssertions

  alias Songmate.Music.GenreRepo
  alias Songmate.Music.Genre

  describe "batch_get_or_create_genres/2" do
    test "returns a list of Genre records for every input item" do
      existing_attrs = valid_genre_attrs()
      GenreRepo.create_genre(existing_attrs)
      new_attrs = %{name: "to be inserted"}

      result = GenreRepo.batch_get_or_create_genres([existing_attrs, new_attrs], order: true)

      assert [%Genre{}, %Genre{}] = result
    end

    test "when input is empty, returns empty" do
      assert Enum.empty?(GenreRepo.batch_get_or_create_genres([], order: true))
    end

    test "when order: true return the records in the same order as input" do
      attrs1 = %{name: "name1"}
      attrs2 = %{name: "name2"}
      attrs3 = %{name: "name3"}

      first_input = [attrs1, attrs2, attrs3]
      first_result = GenreRepo.batch_get_or_create_genres(first_input, order: true)
      assert_same_list_by(:name, first_input, first_result)

      second_input = [attrs2, attrs1, attrs3]
      second_result = GenreRepo.batch_get_or_create_genres(second_input, order: true)
      assert_same_list_by(:name, second_input, second_result)

      third_input = [attrs3, attrs2, attrs1]
      third_result = GenreRepo.batch_get_or_create_genres(third_input, order: true)
      assert_same_list_by(:name, third_input, third_result)
    end
  end

  describe "genres" do
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    test "create_genre/1 with valid data creates a genre" do
      assert {:ok, %Genre{} = genre} = GenreRepo.create_genre(valid_genre_attrs())
      assert genre.name == "Modern Rock"
    end

    test "create_genre/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = GenreRepo.create_genre(@invalid_attrs)
    end

    test "update_genre/2 with valid data updates the genre" do
      genre = genre_fixture()
      assert {:ok, %Genre{} = genre} = GenreRepo.update_genre(genre, @update_attrs)
      assert genre.name == "some updated name"
    end

    test "update_genre/2 with invalid data returns error changeset" do
      genre = genre_fixture()
      assert {:error, %Ecto.Changeset{}} = GenreRepo.update_genre(genre, @invalid_attrs)
    end
  end
end
