defmodule Talkin.API.RoomController do
  use Talkin.Web, :controller
  import Talkin.Plugs.Session
  alias Talkin.Room

  plug :fetch_current_user_from_token
  plug :fetch_user_current_location

  def create(conn, params) do
    %{current_user: current_user, user_location: user_location} = conn.assigns
    changeset = Room.changeset(%Room{}, params |> Map.put("location", user_location))
    case Repo.insert(changeset) do
      {:ok, room} ->
         notify_and_render(conn, room)
      {:error, changeset} ->
        render(conn, "error.json", changeset)
    end
  end

  defp notify_and_render(conn, room) do
    Talkin.Endpoint.broadcast("users:0RWVmc4Y0d3c1huc", "new:channel", %{ user: "System", room: Talkin.Room.display_as_json(room) })
    render(conn, "room.json", room)
  end
end
