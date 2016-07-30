defmodule Talkin.API.Facebook.AuthView do
  use Talkin.Web, :view

  def render("login.json", user) do
    %{id: user.id,
      name: user.name}
  end
end
