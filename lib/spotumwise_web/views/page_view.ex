defmodule SpotumwiseWeb.PageView do
  use SpotumwiseWeb, :view

  def render("index.html", assigns) do
    "top songs: \n#{Enum.join(assigns.names, " | ")}"
  end
end
