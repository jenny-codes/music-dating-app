defmodule Songmate.UseCase.FetchMusicPreference do
  alias Songmate.Accounts.MusicPreferenceService
  alias Songmate.MusicService
  alias Songmate.Music.{Artist, Track, Genre}

  @music_service Application.compile_env(:songmate, [:services, :music_service], MusicService)
  @music_pref_service Application.compile_env(
                        :songmate,
                        [:services, :music_preference_service],
                        MusicPreferenceService
                      )

  @spec call(integer()) :: %{artist: [Artist.t()], track: [Track.t()], genre: [Genre.t()]}
  def call(user_id) do
    music_prefs =
      @music_pref_service.get_all_by_user([user_id])
      |> Enum.group_by(& &1.type, & &1.type_id)

    artist_ids = music_prefs[:artist] || []
    track_ids = music_prefs[:track] || []
    genre_ids = music_prefs[:genre] || []

    %{
      artist: @music_service.get_artists(artist_ids),
      track: @music_service.get_tracks(track_ids),
      genre: @music_service.get_genres(genre_ids)
    }
  end
end
