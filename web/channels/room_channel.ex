defmodule Talkin.RoomChannel do
    use Talkin.Web, :channel
    alias Talkin.Repo
    alias Talkin.User
    alias Talkin.Room

    def join("rooms:" <> room_token, msg, socket) do
      room = Repo.get_by(Room, token: room_token)
      user = Repo.get_by(User, token: msg["user_token"])
      socket = assign(socket, :user, user)
      if user && room do
        Process.flag(:trap_exit, true)
        send(self, {:after_join, %{user: user.name}})
        {:ok, socket}
      else
        {:error, %{reason: "can't do this"}}
      end
    end

    def handle_info({:after_join, msg}, socket) do
        broadcast! socket, "user:entered", %{user: user_name(socket)}
        push socket, "join", %{status: "connected"}
        {:noreply, socket}
    end

    def terminate(_reason, _socket) do
        :ok
    end

    # def handle_in("new:msg", msg, socket) do
    #     broadcast! socket, "new:msg", %{user: msg["user"], body: msg["body"]}
    #     {:reply, {:ok, %{msg: msg["body"]}}, assign(socket, :user, msg["user"])}
    # end

    def handle_in("new:msg", msg, socket) do
        broadcast! socket, "new:msg", %{user: user_name(socket), body: msg["body"]}
        {:reply, {:ok, %{msg: msg["body"]}}, socket}
    end

    def user_name(socket) do
      socket.assigns[:user].name
    end
    # [BROADCAST] Talkin.Endpoint.broadcast "rooms:lobby", "new:msg", %{user: "andre", body: "iex"}
    # [BROADCAST] Talkin.Endpoint.broadcast "rooms:lobby", "channel:list", %{user: "andre", body: "iex"}
end
