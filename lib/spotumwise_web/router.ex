defmodule SpotumwiseWeb.Router do
  use SpotumwiseWeb, :router

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

  scope "/", SpotumwiseWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/authorize", UserController, :authorize
    get "/authenticate", UserController, :authenticate
  end

  # Other scopes may use custom stacks.
  # scope "/api", SpotumwiseWeb do
  #   pipe_through :api
  # end
end
