defmodule Talkin.UserChannel do
    use Talkin.Web, :channel
    alias Talkin.Repo
    alias Talkin.User

    def join("users:" <> token, message, socket) do
      user = Repo.get_by(User, token: token)
      if user do
        Process.flag(:trap_exit, true)
        send(self, {:after_join, message})
        {:ok, socket}
      else
        {:error, %{reason: "can't do this"}}
      end
    end

    def join("users:" <> _anything, _message, _socket) do
      {:error, %{reason: "can't do this"}}
    end

    def handle_info({:after_join, _msg}, socket) do
      push socket, "users:load_content", %{user: "System", rooms: Talkin.Room.list_as_json}
      push socket, "join", %{status: "connected"}
      {:noreply, socket}
    end

    def terminate(_reason, _socket) do
      :ok
    end

    def handle_in("users:load_content", msg, socket) do
      broadcast! socket, "users:new:msg", %{user: msg["user"], body: msg["body"]}
      {:reply, {:ok, %{msg: msg["body"]}}, assign(socket, :user, msg["user"])}
    end

    def handle_in("users:new:channel", msg, socket) do
      broadcast! socket, "new:channel", %{ user: msg.user, room: msg.room }
    end
    # [BROADCAST] Talkin.Endpoint.broadcast "rooms:lobby", "new:msg", %{user: "andre", body: "iex"}
    # [BROADCAST] Talkin.Endpoint.broadcast "rooms:lobby", "channel:list", %{user: "andre", body: "iex"}
end
