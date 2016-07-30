defmodule Talkin.RoomTest do
  use Talkin.ModelCase

  alias Talkin.Room

  @valid_attrs %{key: "some content", private: true, token: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Room.changeset(%Room{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Room.changeset(%Room{}, @invalid_attrs)
    refute changeset.valid?
  end
end
