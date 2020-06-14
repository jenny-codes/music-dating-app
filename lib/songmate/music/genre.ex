defmodule Songmate.Music.Genre do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Songmate.Music.{Artist, Genre}
  alias Songmate.Repo

  schema "genres" do
    field(:name, :string)

    many_to_many(:artists, Artist, join_through: "artists_genres")
  end

  @doc false
  def changeset(genre, attrs) do
    genre
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end

  def insert_and_get_all([]), do: []

  def insert_and_get_all(genres) do
    Repo.insert_all(Genre, genres, on_conflict: :nothing)
    genre_names = Enum.map(genres, & &1.name)
    Repo.all(from(g in Genre, where: g.name in ^genre_names))
  end

  def get_or_create_by!(attr_name, attrs) do
    Repo.get_by(Genre, [{attr_name, attrs[attr_name]}]) || Repo.insert!(Genre.changeset(%Genre{}, attrs))
  end
end
