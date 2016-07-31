defmodule Talkin.Plugs.Session do
  import Plug.Conn
  alias Talkin.User
  alias Talkin.UserSession
  alias Talkin.Repo

  def fetch_current_user_from_token(conn, _) do
    current_user = User |> Repo.get_by(token: conn.params["token"])
    assign(conn, :current_user, current_user)
  end

  def fetch_current_user_from_session(conn, _) do
    require IEx
    IEx.pry
  end

  def fetch_user_current_location(conn, _) do
    user_location = conn.assigns[:current_user]
    |> UserSession.last_location
    assign(conn, :user_location, user_location)
  end
end
