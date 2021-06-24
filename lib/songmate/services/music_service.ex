defmodule Songmate.MusicService do
  alias Songmate.Music.{ArtistService, TrackService, GenreService}
  alias Songmate.Music.{Artist, Track, Genre}

  def batch_get_music_records(%{artist: artist_ids, track: track_ids, genre: genre_ids}) do
    %{
      artist: ArtistService.get_artists(artist_ids),
      track: TrackService.get_tracks(track_ids),
      genre: GenreService.get_genres(genre_ids)
    }
  end

  def type_for(struct) do
    case struct.__struct__ do
      Artist -> :artist
      Track -> :track
      Genre -> :genre
    end
  end
end
