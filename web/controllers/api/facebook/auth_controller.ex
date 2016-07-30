defmodule Talkin.API.Facebook.AuthController do
  use Talkin.Web, :controller

  def login(conn, %{"access_token" => access_token}) do
    access_token
    |> Poison.encode!
    |> render(access_token: access_token)
  end
end
