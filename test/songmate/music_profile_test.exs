defmodule Songmate.MusicProfileTest do
  use Songmate.DataCase

  alias Songmate.MusicProfile
  alias Songmate.MusicProfile.Profile

  describe "music_profiles" do
    def profile_fixture(attrs \\ %{}) do
      MusicProfile.create_profile(attrs)
    end

    test "list_music_profiles/0 returns all music_profiles" do
      profile = profile_fixture()
      assert MusicProfile.list_music_profiles() == [profile]
    end

    test "get_profile!/1 returns the profile with given id" do
      profile = profile_fixture()
      assert MusicProfile.get_profile!(profile.id) == profile
    end

    test "create_profile/1 with valid profile association creates a profile" do
      profile = MusicProfile.create_profile(%{user: valid_user_attrs()})

      assert profile.user.id
      assert profile.user.name == "Bass Wannabe"
    end

    test "create_profile/1 with artists preference associations creates associations" do
      profile = MusicProfile.create_profile(
        %{
          user: valid_user_attrs(),
          artist_preferences: [%{
            rank: 1,
            artist: valid_artist_attrs()
          }]
        }
      )

      artist_pref = profile
                    |> Repo.preload(artist_preferences: [:artist])
                    |> fn profile -> profile.artist_preferences end.()
                    |> List.first()

      assert artist_pref.rank == 1
      assert artist_pref.artist.name == "9m88"
    end

    test "create_profile/1 with track preference associations creates associations" do
      profile = MusicProfile.create_profile(
        %{
          user: valid_user_attrs(),
          track_preferences: [%{
            rank: 1,
            track: valid_track_attrs()
          }]
        }
      )

      track_pref = profile
                   |> Repo.preload(track_preferences: [:track])
                   |> fn profile -> profile.track_preferences end.()
                   |> List.first()

      assert track_pref.rank == 1
      assert track_pref.track.name == "Rebellion (Lies)"
    end

    test "create_profile/1 with genre preference associations creates associations" do
      profile = MusicProfile.create_profile(
        %{
          user: valid_user_attrs(),
          genre_preferences: [%{
            rank: 1,
            genre: valid_genre_attrs()
          }]
        }
      )

      genre_pref = profile
                   |> Repo.preload(genre_preferences: [:genre])
                   |> fn profile -> profile.genre_preferences end.()
                   |> List.first()

      assert genre_pref.rank == 1
      assert genre_pref.genre.name == "Modern Rock"
    end

    test "delete_profile/1 deletes the user profile" do
      profile = profile_fixture()
      assert {:ok, %Profile{}} = MusicProfile.delete_profile(profile)
      assert_raise Ecto.NoResultsError, fn -> MusicProfile.get_profile!(profile.id) end
    end

    test "delete Account.User deletes associated profile and preferences" do
      profile = profile_fixture(
        %{
          user: valid_user_attrs(),
          artist_preferences: [%{
            rank: 1,
            artist: valid_artist_attrs()
          }]
        }
      )

      MusicProfile.delete_profile(profile)

      assert Repo.all(from(ap in MusicProfile.ArtistPreference, where: ap.music_profile_id == ^profile.id)) == []
      # Make sure the associated user and artist are not deleted.
      assert length(Repo.all(Songmate.Music.Artist)) == 1
      assert Repo.get!(Songmate.Accounts.User, Repo.preload(profile, :user).user.id)
    end

    test "change_profile/1 returns a profile changeset" do
      profile = profile_fixture()
      assert %Ecto.Changeset{} = MusicProfile.change_profile(profile)
    end
  end
end
