defmodule Spotumwise.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Spotumwise.Connection
  alias Spotumwise.User
  alias Spotumwise.Repo

  schema "users" do
    field :bio, :string
    field :name, :string
    field :spotify_id, :string
    field :fav_track, :string
    field :top_tracks, {:array, :string}
    field :top_artists, {:array, :string}
    field :genres, {:array, :string}

    has_many(:connections, Connection)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :bio, :spotify_id, :fav_track, :top_tracks, :top_artists, :genres])
    |> validate_required([:name, :spotify_id])
    |> unique_constraint(:spotify_id)
  end

  @track_score 10
  @artist_score 5
  @genre_score 2

  def match_score(user1, user2) do
    user1_tops = [
      tracks: user1.top_tracks |> MapSet.new(),
      artists: user1.top_artists |> MapSet.new(),
      genres: user1.genres |> MapSet.new()
    ]

    user2_tops = [
      tracks: user2.top_tracks |> MapSet.new(),
      artists: user2.top_artists |> MapSet.new(),
      genres: user2.genres |> MapSet.new()
    ]

    shared_tracks = MapSet.intersection(user1_tops[:tracks], user2_tops[:tracks])
    shared_artists = MapSet.intersection(user1_tops[:artists], user2_tops[:artists])
    shared_genres = MapSet.intersection(user1_tops[:genres], user2_tops[:genres])

    Enum.count(shared_tracks) * @track_score +
      Enum.count(shared_artists) * @artist_score +
      Enum.count(shared_genres) * @genre_score
  end

  def build_user_connections(user) do
    format_result = fn {{name, score}, rank} ->
      {rank, name, score}
    end

    Repo.all(User)
    |> Enum.map(fn user2 ->
      case user2 do
        ^user -> nil
        user2 -> {user2.name, match_score(user, user2)}
      end
    end)
    |> Enum.reject(&is_nil(&1))
    |> Enum.sort_by(&elem(&1, 1), &>=/2)
    |> Enum.with_index(1)
    |> Enum.take(3)
    |> Enum.map(format_result)
  end
end
