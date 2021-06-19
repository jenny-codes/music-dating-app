defmodule Songmate.MusicService do
  alias Songmate.Music.{ArtistRepo, TrackRepo, GenreRepo}

  def batch_get_music_records(%{artist: artist_ids, track: track_ids, genre: genre_ids}) do
    %{
      artist: ArtistRepo.get_artists(artist_ids),
      track: TrackRepo.get_tracks(track_ids),
      genre: GenreRepo.get_genres(genre_ids)
    }
  end
end
