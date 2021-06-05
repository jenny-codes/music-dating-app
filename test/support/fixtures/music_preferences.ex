defmodule Songmate.Fixtures.MusicPreferences do
  @behaviour Songmate.MusicPreferences

  defmodule FakePreference do
    defstruct [:user_id, :artist, :track, :genre]
  end

  @impl Songmate.MusicPreferences
  def list_preferences(_type, _user_ids) do
    [
      %FakePreference{artist: "Coldplay"},
      %FakePreference{artist: "Coldplay"},
      %FakePreference{artist: "Coldplay"},
      %FakePreference{track: "Yellow"},
      %FakePreference{genre: "coolkid pop"}
    ]
  end

  @impl Songmate.MusicPreferences
  def batch_create_artist_preferences(_artists, _user), do: nil

  @impl Songmate.MusicPreferences
  def batch_create_track_preferences(_tracks, _user), do: nil

  @impl Songmate.MusicPreferences
  def batch_create_genre_preferences(_genres, _user), do: nil
end
