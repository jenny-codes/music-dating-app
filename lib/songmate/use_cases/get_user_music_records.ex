defmodule Songmate.UseCase.GetUserMusicRecords do
  alias Songmate.Accounts.MusicPreferenceService
  alias Songmate.MusicService
  alias Songmate.Music.{Artist, Track, Genre}

  @spec call(integer()) :: %{artist: [Artist.t()], track: [Track.t()], genre: [Genre.t()]}
  def call(user_id) do
    music_prefs =
      MusicPreferenceService.get_all_by_user([user_id])
      |> Enum.group_by(& &1.type, & &1.type_id)

    artist_ids = music_prefs[:artist] || []
    track_ids = music_prefs[:track] || []
    genre_ids = music_prefs[:genre] || []

    %{
      artist: MusicService.get_artists(artist_ids),
      track: MusicService.get_tracks(track_ids),
      genre: MusicService.get_genres(genre_ids)
    }
  end
end
