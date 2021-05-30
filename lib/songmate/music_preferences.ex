defmodule Songmate.MusicPreferences do
  @moduledoc """
  The MusicPreferences context.
  """

  import Ecto.Query, warn: false
  alias Songmate.Repo

  alias Songmate.MusicPreferences.{ArtistPreference, TrackPreference, GenrePreference}
  alias Songmate.Music.{Artist, Track, Genre}
  alias Songmate.Accounts.User

  @spec batch_create_artist_preferences([%Artist{}] | nil, User.t()) :: any
  def batch_create_artist_preferences(nil, _user), do: nil

  def batch_create_artist_preferences(artists, user) do
    build_pref_attrs = fn {artist, rank} ->
      %{
        user_id: user.id,
        artist_id: artist.id,
        rank: rank,
        inserted_at: NaiveDateTime.local_now(),
        updated_at: NaiveDateTime.local_now()
      }
    end

    prefs =
      artists
      |> Enum.with_index(1)
      |> Enum.map(build_pref_attrs)

    Repo.insert_all(ArtistPreference, prefs,
      on_conflict: {:replace, [:artist_id]},
      conflict_target: [:user_id, :artist_id, :rank]
    )
  end

  @spec batch_create_track_preferences([%Track{}] | nil, User.t()) :: any
  def batch_create_track_preferences(nil, _user), do: nil

  def batch_create_track_preferences(tracks, user) do
    build_pref_attrs = fn {track, rank} ->
      %{
        user_id: user.id,
        track_id: track.id,
        rank: rank,
        inserted_at: NaiveDateTime.local_now(),
        updated_at: NaiveDateTime.local_now()
      }
    end

    prefs =
      tracks
      |> Enum.with_index(1)
      |> Enum.map(build_pref_attrs)

    Repo.insert_all(TrackPreference, prefs,
      on_conflict: {:replace, [:track_id]},
      conflict_target: [:user_id, :track_id, :rank]
    )
  end

  @spec batch_create_genre_preferences([%Genre{}] | nil, User.t()) :: any
  def batch_create_genre_preferences(nil, _user), do: nil

  def batch_create_genre_preferences(genres, user) do
    build_pref_attrs = fn {genre, rank} ->
      %{
        user_id: user.id,
        genre_id: genre.id,
        rank: rank,
        inserted_at: NaiveDateTime.local_now(),
        updated_at: NaiveDateTime.local_now()
      }
    end

    prefs =
      genres
      |> Enum.with_index(1)
      |> Enum.map(build_pref_attrs)

    Repo.insert_all(GenrePreference, prefs,
      on_conflict: {:replace, [:genre_id]},
      conflict_target: [:user_id, :genre_id, :rank]
    )
  end
end
