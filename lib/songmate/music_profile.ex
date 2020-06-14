defmodule Songmate.MusicProfile do
  @moduledoc """
  The MusicProfile context.
  """

  import Ecto.Query, warn: false
  alias Songmate.Repo

  alias Songmate.MusicProfile.{Profile, ArtistPreference, TrackPreference, GenrePreference}
  alias Songmate.Music.{Artist, Track, Genre}
  alias Songmate.Accounts

  @doc """
  Returns the list of music_profiles.

  ## Examples

      iex> list_music_profiles()
      [%User{}, ...]

  """
  def list_music_profiles do
    Repo.all(Profile)
  end

  @doc """
  Gets a single profile.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_profile!(123)
      %User{}

      iex> get_profile!(456)
      ** (Ecto.NoResultsError)

  """
  def get_profile!(id), do: Repo.get!(Profile, id)

  @doc """
  Creates a profile.

  ## Examples

      iex> create_profile(%{field: value})
      {:ok, %User{}}

      iex> create_profile(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_profile(attrs \\ %{}) do
    {:ok, profile} = %Profile{}
                     |> Profile.changeset(attrs)
                     |> Ecto.Changeset.cast_assoc(:user, with: &Accounts.User.changeset/2)
                     |> Repo.insert()

    create_artist_preferences_for_profile(profile, attrs[:artist_preferences])
    create_track_preferences_for_profile(profile, attrs[:track_preferences])
    create_genre_preferences_for_profile(profile, attrs[:genre_preferences])
    profile
  end

  def create_or_update_profile(attrs \\ %{}) do
    profile = case Repo.preload(attrs[:user], :music_profile).music_profile do
      nil ->
        {:ok, profile} = %Profile{}
                         |> Profile.changeset(attrs)
                         |> Ecto.Changeset.put_assoc(:user, attrs[:user])
                         |> Repo.insert(
                              on_conflict: :replace_all,
                              conflict_target: [{:music_profile_id, :artist_id}, {:music_profile_id, :rank}]
                            )
        profile
      profile -> profile
    end

    create_artist_preferences_for_profile(profile, attrs[:artist_preferences])
    create_track_preferences_for_profile(profile, attrs[:track_preferences])
    create_genre_preferences_for_profile(profile, attrs[:genre_preferences])
    profile
  end

  @doc """
  Updates a profile.

  ## Examples

      iex> update_profile(profile, %{field: new_value})
      {:ok, %User{}}

      iex> update_profile(profile, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_profile(%Profile{} = profile, attrs) do
    profile
    |> Profile.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a profile.

  ## Examples

      iex> delete_profile(profile)
      {:ok, %User{}}

      iex> delete_profile(profile)
      {:error, %Ecto.Changeset{}}

  """
  def delete_profile(%Profile{} = profile) do
    Repo.delete(profile)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking profile changes.

  ## Examples

      iex> change_profile(profile)
      %Ecto.Changeset{source: %Profile{}}

  """
  def change_profile(%Profile{} = profile) do
    Profile.changeset(profile, %{})
  end

  alias Songmate.MusicProfile.ArtistPreference

  @doc """
  Returns the list of artist_preferences.

  ## Examples

      iex> list_artist_preferences()
      [%ArtistPreference{}, ...]

  """
  def list_artist_preferences do
    Repo.all(ArtistPreference)
  end

  @doc """
  Gets a single artist_preference.

  Raises `Ecto.NoResultsError` if the Artist preference does not exist.

  ## Examples

      iex> get_artist_preference!(123)
      %ArtistPreference{}

      iex> get_artist_preference!(456)
      ** (Ecto.NoResultsError)

  """
  def get_artist_preference!(id), do: Repo.get!(ArtistPreference, id)

  @doc """
  Creates a artist_preference.

  ## Examples

      iex> create_artist_preference(%{field: value})
      {:ok, %ArtistPreference{}}

      iex> create_artist_preference(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
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
      %{pref | artist: Artist.get_or_create_by!(:spotify_id, pref[:artist])}
    end

    add_profile_attr = fn pref ->
      Map.put(pref, :music_profile, profile)
    end

    prefs
    |> Enum.map(build_artist_attr)
    |> Enum.map(add_profile_attr)
    |> Enum.map(&create_artist_preference!/1)
  end

  @doc """
  Updates a artist_preference.

  ## Examples

      iex> update_artist_preference(artist_preference, %{field: new_value})
      {:ok, %ArtistPreference{}}

      iex> update_artist_preference(artist_preference, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_artist_preference(%ArtistPreference{} = artist_preference, attrs) do
    artist_preference
    |> ArtistPreference.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a artist_preference.

  ## Examples

      iex> delete_artist_preference(artist_preference)
      {:ok, %ArtistPreference{}}

      iex> delete_artist_preference(artist_preference)
      {:error, %Ecto.Changeset{}}

  """
  def delete_artist_preference(%ArtistPreference{} = artist_preference) do
    Repo.delete(artist_preference)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking artist_preference changes.

  ## Examples

      iex> change_artist_preference(artist_preference)
      %Ecto.Changeset{source: %ArtistPreference{}}

  """
  def change_artist_preference(%ArtistPreference{} = artist_preference) do
    ArtistPreference.changeset(artist_preference, %{})
  end

  alias Songmate.MusicProfile.TrackPreference

  @doc """
  Returns the list of track_preferences.

  ## Examples

      iex> list_track_preferences()
      [%TrackPreference{}, ...]

  """
  def list_track_preferences do
    Repo.all(TrackPreference)
  end

  @doc """
  Gets a single track_preference.

  Raises `Ecto.NoResultsError` if the Track preference does not exist.

  ## Examples

      iex> get_track_preference!(123)
      %TrackPreference{}

      iex> get_track_preference!(456)
      ** (Ecto.NoResultsError)

  """
  def get_track_preference!(id), do: Repo.get!(TrackPreference, id)

  @doc """
  Creates a track_preference.

  ## Examples

      iex> create_track_preference(%{field: value})
      {:ok, %TrackPreference{}}

      iex> create_track_preference(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
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
      %{pref | track: Track.get_or_create_by!(:spotify_id, pref[:track])}
    end

    add_profile_attr = fn pref ->
      Map.put(pref, :music_profile, profile)
    end

    prefs
    |> Enum.map(build_track_attr)
    |> Enum.map(add_profile_attr)
    |> Enum.map(&create_track_preference!/1)
  end

  @doc """
  Updates a track_preference.

  ## Examples

      iex> update_track_preference(track_preference, %{field: new_value})
      {:ok, %TrackPreference{}}

      iex> update_track_preference(track_preference, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_track_preference(%TrackPreference{} = track_preference, attrs) do
    track_preference
    |> TrackPreference.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a track_preference.

  ## Examples

      iex> delete_track_preference(track_preference)
      {:ok, %TrackPreference{}}

      iex> delete_track_preference(track_preference)
      {:error, %Ecto.Changeset{}}

  """
  def delete_track_preference(%TrackPreference{} = track_preference) do
    Repo.delete(track_preference)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking track_preference changes.

  ## Examples

      iex> change_track_preference(track_preference)
      %Ecto.Changeset{source: %TrackPreference{}}

  """
  def change_track_preference(%TrackPreference{} = track_preference) do
    TrackPreference.changeset(track_preference, %{})
  end

  alias Songmate.MusicProfile.GenrePreference

  @doc """
  Returns the list of genre_preferences.

  ## Examples

      iex> list_genre_preferences()
      [%GenrePreference{}, ...]

  """
  def list_genre_preferences do
    Repo.all(GenrePreference)
  end

  @doc """
  Gets a single genre_preference.

  Raises `Ecto.NoResultsError` if the Genre preference does not exist.

  ## Examples

      iex> get_genre_preference!(123)
      %GenrePreference{}

      iex> get_genre_preference!(456)
      ** (Ecto.NoResultsError)

  """
  def get_genre_preference!(id), do: Repo.get!(GenrePreference, id)

  @doc """
  Creates a genre_preference.

  ## Examples

      iex> create_genre_preference(%{field: value})
      {:ok, %GenrePreference{}}

      iex> create_genre_preference(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
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
      %{pref | genre: Genre.get_or_create_by!(:name, pref[:genre])}
    end

    add_profile_attr = fn pref ->
      Map.put(pref, :music_profile, profile)
    end

    prefs
    |> Enum.map(build_genre_attr)
    |> Enum.map(add_profile_attr)
    |> Enum.map(&create_genre_preference!/1)

  end

  @doc """
  Updates a genre_preference.

  ## Examples

      iex> update_genre_preference(genre_preference, %{field: new_value})
      {:ok, %GenrePreference{}}

      iex> update_genre_preference(genre_preference, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_genre_preference(%GenrePreference{} = genre_preference, attrs) do
    genre_preference
    |> GenrePreference.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a genre_preference.

  ## Examples

      iex> delete_genre_preference(genre_preference)
      {:ok, %GenrePreference{}}

      iex> delete_genre_preference(genre_preference)
      {:error, %Ecto.Changeset{}}

  """
  def delete_genre_preference(%GenrePreference{} = genre_preference) do
    Repo.delete(genre_preference)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking genre_preference changes.

  ## Examples

      iex> change_genre_preference(genre_preference)
      %Ecto.Changeset{source: %GenrePreference{}}

  """
  def change_genre_preference(%GenrePreference{} = genre_preference) do
    GenrePreference.changeset(genre_preference, %{})
  end
end
