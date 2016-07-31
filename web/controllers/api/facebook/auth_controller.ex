defmodule Talkin.API.Facebook.AuthController do
  use Talkin.Web, :controller
  alias Talkin.User.FacebookCreation

  def login(conn, %{"access_token" => access_token}) do
    oauth_token = OAuth2.AccessToken.new(access_token, %OAuth2.Client{})
    FacebookCreation.find_or_create_user_by_access_token(oauth_token)
    |> response(conn)
  end

  defp response({:error, _changeset}, _conn) do
  end

  defp response({_, user}, conn) do
    conn
    |> FacebookCreation.create_session(user)
    |> render("login.json", user)
  end
end
