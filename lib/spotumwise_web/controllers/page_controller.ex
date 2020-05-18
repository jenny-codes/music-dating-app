defmodule SpotumwiseWeb.PageController do
  use SpotumwiseWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
  
  def info(conn, _params) do
	render(conn, "info.html")
  end

  
  def login(conn, _params) do
	render(conn, "login.html")
  end

  
  def music(conn, _params) do
	render(conn, "music.html")
  end

  
  def chat(conn, _params) do
	render(conn, "chat.html")
  end

    
end
