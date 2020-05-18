defmodule SpotumwiseWeb.PageController do
  use SpotumwiseWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
