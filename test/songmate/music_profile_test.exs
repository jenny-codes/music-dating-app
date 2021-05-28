defmodule Songmate.MusicProfileTest do
  use Songmate.DataCase

  alias Songmate.MusicProfile
  alias Songmate.MusicProfile.{ArtistPreference, TrackPreference, GenrePreference}
  alias Songmate.Music.{Artist, Track, Genre}

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(valid_user_attrs())
      |> Songmate.Accounts.create_user()

    Repo.preload(user, :credential)
  end

  describe "create_music_profile/1 " do
    test "nothing happens with no preferences given" do
      user = user_fixture()

      result_user = MusicProfile.create_music_profile(user, %{})

      assert result_user == user
    end

    test "with artists preference associations creates associations" do
      user = user_fixture()

      MusicProfile.create_music_profile(user, %{
        artist_preferences: [
          %{
            rank: 1,
            artist: valid_artist_attrs()
          }
        ]
      })

      result_artist_pref =
        ArtistPreference
        |> Repo.get_by(user_id: user.id)
        |> Repo.preload(:artist)

      assert result_artist_pref
      assert result_artist_pref.rank == 1
    end

    test "with track preference associations creates associations" do
      user = user_fixture()

      MusicProfile.create_music_profile(user, %{
        track_preferences: [
          %{
            rank: 1,
            track: valid_track_attrs()
          }
        ]
      })

      result_track_pref =
        TrackPreference
        |> Repo.get_by(user_id: user.id)
        |> Repo.preload(:track)

      assert result_track_pref
      assert result_track_pref.rank == 1
    end

    test "with genre preference associations creates associations" do
      user = user_fixture()

      MusicProfile.create_music_profile(user, %{
        genre_preferences: [
          %{
            rank: 1,
            genre: valid_genre_attrs()
          }
        ]
      })

      result_genre_pref =
        GenrePreference
        |> Repo.get_by(user_id: user.id)
        |> Repo.preload(:genre)

      assert result_genre_pref
      assert result_genre_pref.rank == 1
    end
  end

  describe "delete situation" do
    test "delete User deletes associated preferences" do
      user = user_fixture()

      MusicPreference.create_music_preference(user, %{
        artist_preferences: [
          %{
            rank: 1,
            artist: valid_artist_attrs()
          }
        ],
        track_preferences: [
          %{
            rank: 1,
            track: valid_track_attrs()
          }
        ],
        genre_preferences: [
          %{
            rank: 1,
            genre: valid_genre_attrs()
          }
        ]
      })

      {:ok, _} = Repo.delete(user)

      refute Repo.exists?(from(pref in ArtistPreference, where: pref.user_id == ^user.id))
      refute Repo.exists?(from(pref in TrackPreference, where: pref.user_id == ^user.id))
      refute Repo.exists?(from(pref in GenrePreference, where: pref.user_id == ^user.id))
    end

    test "delete Preferences does not delete associated user or music types" do
      user = user_fixture()

      prefs =
        MusicPreference.create_music_preference(user, %{
          artist_preferences: [
            %{
              rank: 1,
              artist: valid_artist_attrs()
            }
          ],
          track_preferences: [
            %{
              rank: 1,
              track: valid_track_attrs()
            }
          ],
          genre_preferences: [
            %{
              rank: 1,
              genre: valid_genre_attrs()
            }
          ]
        })

      prefs
      |> Enum.flat_map(fn {_k, v} -> v end)
      |> Enum.each(&Repo.delete/1)

      assert Repo.exists?(Artist)
      assert Repo.exists?(Track)
      assert Repo.exists?(Genre)
    end
  end
end
