defmodule Songamte.Fixtures.SpotifyPort do
  def fetch_listening_history(_conn) do
    %{artists: [], tracks: [], genres: []}
  end
end
