defmodule Songmate.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Songmate.Accounts.{User, Credential}
  alias Songmate.MusicProfile
  alias Songmate.Repo

  schema "users" do
    field(:bio, :string)
    field(:name, :string)
    field(:avatar, :string)
    field(:spotify_id, :string)
    field(:fav_track, :string)
    field(:top_tracks, {:array, :string})
    field(:top_artists, {:array, :string})
    field(:genres, {:array, :string})

    has_one(:credential, Credential)
    has_one(:music_profile, MusicProfile.Profile)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [
      :name,
      :bio,
      :avatar,
      :spotify_id,
      :fav_track,
      :top_tracks,
      :top_artists,
      :genres
    ])
    |> validate_required([:name])
    |> unique_constraint(:spotify_id)
  end

  @track_score 10
  @artist_score 5
  @genre_score 2

  def match_score(user1_prefs, user2) do
    legacy_top_tracks =
      (user2.top_tracks || [])
      |> Enum.map(fn t -> Regex.run(~r/.*(?= by )/, t) || [t] |> Enum.at(0) end)

    user2_tops = [
      tracks: legacy_top_tracks |> MapSet.new(),
      artists: (user2.top_artists || []) |> MapSet.new(),
      genres: (user2.genres || []) |> MapSet.new()
    ]

    shared_tracks =
      MapSet.intersection(user1_prefs[:top_tracks] |> MapSet.new(), user2_tops[:tracks])

    shared_artists =
      MapSet.intersection(user1_prefs[:top_artists] |> MapSet.new(), user2_tops[:artists])

    shared_genres =
      MapSet.intersection(user1_prefs[:top_genres] |> MapSet.new(), user2_tops[:genres])

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
      {user2.name, match_score(user, user2)}
    end)
    |> Enum.reject(&is_nil(&1))
    |> Enum.sort_by(&elem(&1, 1), &>=/2)
    |> Enum.with_index(1)
    |> Enum.slice(1..3)
    |> Enum.map(format_result)
  end
end
