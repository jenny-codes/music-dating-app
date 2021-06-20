defmodule Songmate.Fixtures.ImporterSpotifyService do
  def listening_history(_conn) do
    %{artists: [], tracks: [], genres: []}
  end
end
