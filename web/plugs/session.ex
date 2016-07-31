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
    user_id = conn.private.plug_session["current_user_id"]
    if user_id do
      fetch_from_user_id(conn, user_id)
    else
      redirect_to_login_page(conn)
    end
  end

  def fetch_from_user_id(conn, user_id) do
    current_user = User |> Repo.get(user_id)
    if current_user do
      assign(conn, :current_user, current_user)
    else
      conn |> Phoenix.Controller.redirect(to: "/sign_in")
    end
  end

  def redirect_to_login_page(conn) do
    conn |> Phoenix.Controller.redirect(to: "/sign_in")
  end

  def fetch_user_current_location(conn, _) do
    user_location = conn.assigns[:current_user]
                    |> UserSession.last_location
    assign(conn, :user_location, user_location)
  end
end
