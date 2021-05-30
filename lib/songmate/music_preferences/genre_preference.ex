defmodule Songmate.MusicPreferences.GenrePreference do
  use Ecto.Schema
  import Ecto.Changeset

  alias Songmate.Accounts.User
  alias Songmate.Music.Genre

  schema "genre_preferences" do
    field(:rank, :integer)

    belongs_to(:user, User)
    belongs_to(:genre, Genre)

    timestamps()
  end

  @doc false
  def changeset(genre_preference, attrs) do
    genre_preference
    |> cast(attrs, [:rank, :user_id, :genre_id])
    |> validate_required([:rank, :user_id, :genre_id])
    |> unique_constraint([:rank, :user_id, :genre_id])
  end
end
