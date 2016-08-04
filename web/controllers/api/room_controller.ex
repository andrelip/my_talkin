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
        Talkin.Endpoint.broadcast("users:lJieWRJckxWNEhyb", "new:channel", %{user: "System", rooms: room})
        render(conn, "room.json", room)
      {:error, changeset} ->
        render(conn, "error.json", changeset)
    end
  end
end
