defmodule Songmate.Repo.Migrations.CreateGenres do
  use Ecto.Migration

  def change do
    create table(:artists) do
      add :spotify_id, :string
      add :name, :string
      add :popularity, :integer
    end

    create table(:tracks) do
      add :isrc, :string
      add :spotify_id, :string
      add :name, :string
      add :popularity, :integer
    end

    create table(:genres) do
      add :name, :string
    end

    create table(:artists_tracks) do
      add :artist_id, references(:artists, on_delete: :delete_all, null: false)
      add :track_id, references(:tracks, on_delete: :delete_all, null: false)
    end

    create table(:artists_genres) do
      add :artist_id, references(:artists, on_delete: :delete_all, null: false)
      add :genre_id, references(:genres, on_delete: :delete_all, null: false)
    end

    create unique_index(:artists, [:spotify_id])
    create unique_index(:tracks, [:isrc])
    create unique_index(:tracks, [:spotify_id])
    create unique_index(:genres, [:name])

    create unique_index(:artists_tracks, [:track_id, :artist_id])
    create unique_index(:artists_genres, [:genre_id, :artist_id])
  end
end
