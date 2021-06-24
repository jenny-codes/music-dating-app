defmodule Songmate.UseCase.FetchMusicPreference do
  alias Songmate.Accounts.MusicPreferenceService
  alias Songmate.Music.{ArtistService, TrackService, GenreService}
  alias Songmate.Music.{Artist, Track, Genre}

  @artist_service Application.compile_env(:songmate, [:services, :artist_service], ArtistService)
  @track_service Application.compile_env(:songmate, [:services, :track_service], TrackService)
  @genre_service Application.compile_env(:songmate, [:services, :genre_service], GenreService)
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
      artist: @artist_service.get_artists(artist_ids),
      track: @track_service.get_tracks(track_ids),
      genre: @genre_service.get_genres(genre_ids)
    }
  end
end
