defmodule Songmate.Fixtures.SpotifyService do
  def listening_history(_conn) do
    %{
      artists: [
        %{
          name: "test artist name",
          spotify_id: "test-artist-id",
          popularity: 99
        }
      ],
      tracks: [
        %{
          name: "test track name",
          isrc: "test-track-isrc",
          spotify_id: "test-track-id",
          popularity: 100
        }
      ],
      genres: [
        %{
          name: "test genre name"
        }
      ]
    }
  end
end
