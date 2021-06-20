defmodule Songmate.MusicService do
  alias Songmate.Music.{ArtistService, TrackService, GenreService}

  def batch_get_music_records(%{artist: artist_ids, track: track_ids, genre: genre_ids}) do
    %{
      artist: ArtistService.get_artists(artist_ids),
      track: TrackService.get_tracks(track_ids),
      genre: GenreService.get_genres(genre_ids)
    }
  end
end
