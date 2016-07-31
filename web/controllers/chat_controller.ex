defmodule Talkin.ChatController do
  use Talkin.Web, :controller
  import Talkin.Plugs.Session
  
  plug :fetch_current_user_from_session

  def index(conn, _params) do
    render conn, "lobby.html"
  end
end
