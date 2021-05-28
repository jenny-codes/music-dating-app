defmodule Songmate.MusicPreferences do
  @moduledoc """
  The MusicPreferences context.
  """

  import Ecto.Query, warn: false
  alias Songmate.Repo

  alias Songmate.MusicPreferences.{ArtistPreference, TrackPreference, GenrePreference}
  alias Songmate.Music.{Artist, Track, Genre}
  alias Songmate.Accounts.User

  def create_music_preference(user, attrs \\ %{}) do
    %{
      artist_preferences: batch_create_artist_preferences!(user, attrs[:artist_preferences]),
      track_preferences: batch_create_track_preferences!(user, attrs[:track_preferences]),
      genre_preferences: batch_create_genre_preferences!(user, attrs[:genre_preferences])
    }
  end

  @spec batch_create_artist_preferences!(User.t(), [] | nil) :: any
  def batch_create_artist_preferences!(_user, nil), do: []

  def batch_create_artist_preferences!(user, prefs) do
    build_artist_attr = fn pref ->
      params = [spotify_id: pref[:artist][:spotify_id]]
      %{pref | artist: Repo.get_or_insert_by!(Artist, params, pref[:artist])}
    end

    add_user_attr = fn pref ->
      Map.put(pref, :user, user)
    end

    prefs
    |> Enum.map(build_artist_attr)
    |> Enum.map(add_user_attr)
    |> Enum.map(&create_artist_preference!/1)
  end

  def batch_create_track_preferences!(_user, nil), do: []

  def batch_create_track_preferences!(user, prefs) do
    build_track_attr = fn pref ->
      params =
        if pref[:track][:isrc] do
          [isrc: pref[:track][:isrc]]
        else
          [spotify_id: pref[:track][:spotify_id]]
        end

      %{pref | track: Repo.get_or_insert_by!(Track, params, pref[:track])}
    end

    add_user_attr = fn pref ->
      Map.put(pref, :user, user)
    end

    prefs
    |> Enum.map(build_track_attr)
    |> Enum.map(add_user_attr)
    |> Enum.map(&create_track_preference!/1)
  end

  def batch_create_genre_preferences!(_user, nil), do: []

  def batch_create_genre_preferences!(user, prefs) do
    build_genre_attr = fn pref ->
      params = [name: pref[:genre][:name]]
      %{pref | genre: Repo.get_or_insert_by!(Genre, params, pref[:genre])}
    end

    add_user_attr = fn pref ->
      Map.put(pref, :user, user)
    end

    prefs
    |> Enum.map(build_genre_attr)
    |> Enum.map(add_user_attr)
    |> Enum.map(&create_genre_preference!/1)
  end

  def create_artist_preference!(attrs \\ %{}) do
    %ArtistPreference{}
    |> ArtistPreference.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, attrs[:user])
    |> Ecto.Changeset.put_assoc(:artist, attrs[:artist])
    |> Repo.insert!(on_conflict: :replace_all, conflict_target: [:user_id, :artist_id])
  end

  def create_track_preference!(attrs \\ %{}) do
    %TrackPreference{}
    |> TrackPreference.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, attrs[:user])
    |> Ecto.Changeset.put_assoc(:track, attrs[:track])
    |> Repo.insert!(on_conflict: :replace_all, conflict_target: [:user_id, :track_id])
  end

  def create_genre_preference!(attrs \\ %{}) do
    %GenrePreference{}
    |> GenrePreference.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, attrs[:user])
    |> Ecto.Changeset.put_assoc(:genre, attrs[:genre])
    |> Repo.insert!(on_conflict: :replace_all, conflict_target: [:user_id, :genre_id])
  end
end
