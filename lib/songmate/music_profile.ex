defmodule Songmate.MusicProfile do
  @moduledoc """
  The MusicProfile context.
  """

  import Ecto.Query, warn: false
  alias Songmate.Repo

  alias Songmate.MusicProfile.{Profile, ArtistPreference, TrackPreference, GenrePreference}
  alias Songmate.Music.{Artist, Track, Genre}
  alias Songmate.Accounts

  def list_profiles do
    Repo.all(Profile)
  end

  def create_profile(attrs \\ %{}) do
    {:ok, profile} =
      %Profile{}
      |> Profile.changeset(attrs)
      |> Ecto.Changeset.cast_assoc(:user, with: &Accounts.User.changeset/2)
      |> Repo.insert()

    create_artist_preferences_for_profile(profile, attrs[:artist_preferences])
    create_track_preferences_for_profile(profile, attrs[:track_preferences])
    create_genre_preferences_for_profile(profile, attrs[:genre_preferences])
    profile
  end

  def create_or_update_profile(attrs \\ %{}) do
    profile =
      case Repo.preload(attrs[:user], :music_profile).music_profile do
        nil ->
          {:ok, profile} =
            %Profile{}
            |> Profile.changeset(attrs)
            |> Ecto.Changeset.put_assoc(:user, attrs[:user])
            |> Repo.insert()

          profile

        profile ->
          profile
      end

    create_artist_preferences_for_profile(profile, attrs[:artist_preferences])
    create_track_preferences_for_profile(profile, attrs[:track_preferences])
    create_genre_preferences_for_profile(profile, attrs[:genre_preferences])
    profile
  end

  def update_profile(%Profile{} = profile, attrs) do
    profile
    |> Profile.changeset(attrs)
    |> Repo.update()
  end

  def delete_profile(%Profile{} = profile) do
    Repo.delete(profile)
  end

  def create_artist_preference!(attrs \\ %{}) do
    %ArtistPreference{}
    |> ArtistPreference.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:music_profile, attrs[:music_profile])
    |> Ecto.Changeset.put_assoc(:artist, attrs[:artist])
    |> Repo.insert!(on_conflict: :replace_all, conflict_target: [:music_profile_id, :artist_id])
  end

  def create_artist_preferences_for_profile(profile, nil), do: profile
  def create_artist_preferences_for_profile(profile, []), do: profile

  def create_artist_preferences_for_profile(profile, prefs) do
    build_artist_attr = fn pref ->
      %{pref | artist: Repo.get_or_create_by!(Artist, :spotify_id, pref[:artist])}
    end

    add_profile_attr = fn pref ->
      Map.put(pref, :music_profile, profile)
    end

    prefs
    |> Enum.map(build_artist_attr)
    |> Enum.map(add_profile_attr)
    |> Enum.map(&create_artist_preference!/1)
  end

  def delete_artist_preference(%ArtistPreference{} = artist_preference) do
    Repo.delete(artist_preference)
  end

  def create_track_preference!(attrs \\ %{}) do
    %TrackPreference{}
    |> TrackPreference.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:music_profile, attrs[:music_profile])
    |> Ecto.Changeset.put_assoc(:track, attrs[:track])
    |> Repo.insert!(on_conflict: :replace_all, conflict_target: [:music_profile_id, :track_id])
  end

  def create_track_preferences_for_profile(profile, nil), do: profile
  def create_track_preferences_for_profile(profile, []), do: profile

  def create_track_preferences_for_profile(profile, prefs) do
    build_track_attr = fn pref ->
      %{pref | track: Repo.get_or_create_by!(Track, [:isrc, :spotify_id], pref[:track])}
    end

    add_profile_attr = fn pref ->
      Map.put(pref, :music_profile, profile)
    end

    prefs
    |> Enum.map(build_track_attr)
    |> Enum.map(add_profile_attr)
    |> Enum.map(&create_track_preference!/1)
  end

  def create_genre_preference!(attrs \\ %{}) do
    %GenrePreference{}
    |> GenrePreference.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:music_profile, attrs[:music_profile])
    |> Ecto.Changeset.put_assoc(:genre, attrs[:genre])
    |> Repo.insert!(on_conflict: :replace_all, conflict_target: [:music_profile_id, :genre_id])
  end

  def create_genre_preferences_for_profile(profile, nil), do: profile
  def create_genre_preferences_for_profile(profile, []), do: profile

  def create_genre_preferences_for_profile(profile, prefs) do
    build_genre_attr = fn pref ->
      %{pref | genre: Repo.get_or_create_by!(Genre, :name, pref[:genre])}
    end

    add_profile_attr = fn pref ->
      Map.put(pref, :music_profile, profile)
    end

    prefs
    |> Enum.map(build_genre_attr)
    |> Enum.map(add_profile_attr)
    |> Enum.map(&create_genre_preference!/1)
  end
end
