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
    post "/rooms", API.RoomController, :create
  end

  scope "/", Talkin do
    pipe_through :browser # Use the default browser stack
    get "/login", AuthController, :facebook_login
    get "/login_confirmation", AuthController, :facebook_callback
    get "/logout", AuthController, :logout

    get "/", ChatController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", Talkin do
  #   pipe_through :api
  # end
end
