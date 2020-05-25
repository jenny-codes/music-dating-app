defmodule SongmateWeb.Router do
  use SongmateWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SongmateWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/authorize", UserController, :authorize
    get "/authenticate", UserController, :authenticate
    get "/info", PageController, :info
    get "/login", PageController, :login
    get "/music", PageController, :music
    get "/chat", PageController, :chat
  end

  # Other scopes may use custom stacks.
  # scope "/api", SongmateWeb do
  #   pipe_through :api
  # end
end
