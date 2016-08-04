defmodule Talkin.API.RoomView do
  use Talkin.Web, :view

  def render("room.json", room) do
    %{name: room.name,
      location: Geo.JSON.encode(room.location),
      token: room.token}
  end

  def render("error.json", changeset) do
    errors = Enum.map(changeset.errors, fn {field, detail} ->
      %{
        field: field,
        detail: render_detail(detail)
      }
    end)

    %{errors: errors}
  end

  defp render_detail({message, values}) do
    Enum.reduce values, message, fn {k, v}, acc ->
      require IEx
      IEx.pry
      String.replace(acc, "%{#{k}}", to_string(v))
    end
  end

  defp render_detail(message) do
    message
  end
end
