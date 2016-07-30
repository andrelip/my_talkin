defmodule Talkin.FacebookTest do
  use ExUnit.Case

  alias Facebook

  @working_token "EAADyKhwVZBeQBAIcbShR0okeg6EkcaAx21bCMWtiUPdTjB5K0RI30lGrQu833suGbkofxE0z6emFAJzOLvNircruxH4zvJjCY1oIwtZCQ6g6aS5aq5DZALUyZB3KRs9DHelHWzXt6DEfP7cAu3NxfB4ZCHw9VYuZBR8a13I7ITvQNpdquiojHYJreZCIqjbDJBMTJcvm4349Uw4z0UKZCuKA"
  @invalid_attrs "invalid token"

  test "request_url with valid settings" do
    assert {:ok, _} = Facebook.get_user(@working_token)
  end

  test "request_url with invalid settings" do
    assert {:error, _} = Facebook.get_user(@invalid_attrs)
  end
end
