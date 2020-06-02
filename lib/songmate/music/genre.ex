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

  def insert_and_get_all(genres) do
    genre_struct = Enum.map(genres, &%{name: &1})

    Repo.insert_all(Genre, genre_struct, on_conflict: :nothing)
    Repo.all(from(g in Genre, where: g.name in ^genres))
  end
end
