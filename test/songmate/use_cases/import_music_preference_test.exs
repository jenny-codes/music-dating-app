defmodule Songmate.ImportMusicPreferenceTest do
  use Songmate.DataCase, async: true
  import Songmate.UserFactory
  alias Songmate.UseCase.ImportMusicPreference

  test "import music record and update user" do
    user = create_user(%{preferences_updated_at: nil})

    listening_history = %{
      tracks: [%{spotify_id: "track"}],
      artists: [%{spotify_id: "artist"}],
      genres: [%{name: "genre"}]
    }

    ImportMusicPreference.call(user, %{listening_history: listening_history})

    user =
      Songmate.Accounts.UserService.get_user(user.id) |> Songmate.Repo.preload(:music_preferences)

    assert user.preferences_updated_at
    assert Enum.count(user.music_preferences) == 3
  end

  test "store new music records into database" do
    new_artist_attrs = %{spotify_id: "artist"}
    new_track_attrs = %{spotify_id: "track"}
    new_genre_attrs = %{name: "genre"}
    user = create_user(%{preferences_updated_at: nil})

    listening_history = %{
      artists: [new_artist_attrs],
      tracks: [new_track_attrs],
      genres: [new_genre_attrs]
    }

    ImportMusicPreference.call(user, %{listening_history: listening_history})

    assert Songmate.Repo.get_by(Songmate.Music.Artist, new_artist_attrs)
    assert Songmate.Repo.get_by(Songmate.Music.Track, new_track_attrs)
    assert Songmate.Repo.get_by(Songmate.Music.Genre, new_genre_attrs)
  end
end
