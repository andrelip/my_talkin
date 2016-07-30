defmodule Talkin.API.Facebook.AuthView do
  use Talkin.Web, :view

  def render("login.json", %{access_token: access_token}) do
    access_token
    |> Poison.encode!
  end
end
