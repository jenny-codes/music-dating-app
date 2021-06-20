defmodule Songmate.Fixtures.SpotifyService do
  def listening_history(_conn) do
    %{artists: [], tracks: [], genres: []}
  end
end
