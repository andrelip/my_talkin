defmodule Talkin.Router do
  use Talkin.Web, :router

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

  scope "/api", Talkin do
    pipe_through :api
    post "/facebook/login", API.Facebook.AuthController, :login
    get "/rooms", API.RoomController, :create
  end

  scope "/", Talkin do
    pipe_through :browser # Use the default browser stack

    get "/", ChatController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", Talkin do
  #   pipe_through :api
  # end
end
