defmodule Talkin.API.Facebook.AuthView do
  use Talkin.Web, :view

  def render("login.json", user) do
    %{api_token: user.token,
      name: user.name}
  end
end
