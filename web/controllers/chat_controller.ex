defmodule Talkin.ChatController do
  use Talkin.Web, :controller

  def index(conn, _params) do
    render conn, "lobby.html"
  end
end
