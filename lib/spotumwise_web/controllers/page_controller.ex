defmodule SpotumwiseWeb.PageController do
  use SpotumwiseWeb, :controller

  plug :check_tokens

  def check_tokens(conn, _params) do
    unless Spotify.Authentication.tokens_present?(conn) do
      redirect(conn, to: "/authorize")
    end

    conn
  end

  def index(conn, _params) do
    case Spotify.Personalization.top_tracks(conn) do
      {:ok, %{items: items}} ->
        names = Enum.map(items, & &1.name)
        render(conn, "index.html", names: names)

      {:ok, %{"error" => _error}} ->
        redirect(conn, to: "/authorize")
    end
  end
end
