defmodule Songmate.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :bio, :text
      add :avatar, :string
      add :spotify_id, :string
      add :fav_track, :string
      add :top_tracks, {:array, :string}
      add :top_artists, {:array, :string}
      add :genres, {:array, :string}

      timestamps()
    end

  end
end
