defmodule Talkin.API.Facebook.AuthController do
  use Talkin.Web, :controller

  def login(conn, %{"access_token" => access_token}) do
    conn
    |> render(AccessToken: access_token)
  end
end
