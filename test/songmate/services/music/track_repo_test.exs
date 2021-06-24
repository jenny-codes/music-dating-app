defmodule Songmate.MusicTest do
  use Songmate.DataCase, async: true
  import Songmate.CustomAssertions
  import Songmate.MusicFactory

  alias Songmate.Music.TrackService
  alias Songmate.Music.Track

  def valid_track_attrs do
    %{
      isrc: "USMRG0467010",
      name: "Rebellion (Lies)",
      popularity: 65,
      spotify_id: "0xOeB16JDbBJBJKSdHbElT"
    }
  end

  describe "batch_get_or_create_tracks/2" do
    test "returns a list of Track records for every input item" do
      existing_attrs = valid_track_attrs()
      TrackService.create_track(existing_attrs)
      new_attrs = %{name: "to be inserted", spotify_id: "dont really care"}

      result = TrackService.batch_get_or_create_tracks([existing_attrs, new_attrs], order: true)

      assert [%Track{}, %Track{}] = result
    end

    test "when input is empty, returns empty" do
      assert Enum.empty?(TrackService.batch_get_or_create_tracks([], order: true))
    end

    test "when order: true return the records in the same order as input" do
      attrs1 = %{name: "name1", spotify_id: "1"}
      attrs2 = %{name: "name2", spotify_id: "2"}
      attrs3 = %{name: "name3", spotify_id: "3"}

      first_input = [attrs1, attrs2, attrs3]
      first_result = TrackService.batch_get_or_create_tracks(first_input, order: true)
      assert_same_list_by(:spotify_id, first_input, first_result)

      second_input = [attrs2, attrs1, attrs3]
      second_result = TrackService.batch_get_or_create_tracks(second_input, order: true)
      assert_same_list_by(:spotify_id, second_input, second_result)

      third_input = [attrs3, attrs2, attrs1]
      third_result = TrackService.batch_get_or_create_tracks(third_input, order: true)
      assert_same_list_by(:spotify_id, third_input, third_result)
    end
  end

  describe "tracks" do
    @update_attrs %{
      name: "updated Rebellion",
      popularity: 90
    }
    @invalid_attrs %{name: nil, potify_id: nil}

    test "create_track/1 with valid data creates a track" do
      assert {:ok, %Track{} = track} = TrackService.create_track(valid_track_attrs())
      assert track.isrc == "USMRG0467010"
      assert track.name == "Rebellion (Lies)"
      assert track.popularity == 65
      assert track.spotify_id == "0xOeB16JDbBJBJKSdHbElT"
    end

    test "create_track/1 creates associated artists" do
      track =
        create_track(%{
          artists: [
            %{name: "Arcade Fire", spotify_id: "3kjuyTCjPG1WMFCiyc5IuB"}
          ]
        })

      track = Repo.preload(track, :artists)

      [artist] = track.artists
      assert artist.id
      assert artist.name == "Arcade Fire"
      assert artist.spotify_id == "3kjuyTCjPG1WMFCiyc5IuB"
    end

    test "create_track/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TrackService.create_track(@invalid_attrs)
    end

    test "update_track/2 with valid data updates the track" do
      track = create_track()
      before_isrc = track.isrc
      before_spotify_id = track.spotify_id
      assert {:ok, %Track{} = track} = TrackService.update_track(track, @update_attrs)
      assert track.isrc == before_isrc
      assert track.spotify_id == before_spotify_id
      assert track.name == "updated Rebellion"
      assert track.popularity == 90
    end

    test "update_track/2 with artists updates the association" do
      track =
        create_track(%{
          artists: [
            %{name: "Arcade Fire", spotify_id: "3kjuyTCjPG1WMFCiyc5IuB"}
          ]
        })

      assert {:ok, %Track{artists: [artist]}} =
               TrackService.update_track(
                 track,
                 %{
                   artists: [
                     %{name: "Updated Artist", spotify_id: "updated-spotify-id"}
                   ]
                 }
               )

      assert artist.id
      assert artist.name == "Updated Artist"
      assert artist.spotify_id == "updated-spotify-id"
    end

    test "update_track/2 with invalid data returns error changeset" do
      track = create_track()
      assert {:error, %Ecto.Changeset{}} = TrackService.update_track(track, @invalid_attrs)
    end
  end
end
