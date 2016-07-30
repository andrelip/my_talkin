defmodule Talkin.UserTest do
  use Talkin.ModelCase

  alias Talkin.User

  @valid_attrs %{name: "some content", oauth_expires_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, oauth_token: "some content", uid: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "list all the users in a range" do
    assert User.list == []
  end

  test "list as json" do
    assert User.list_as_json == "[]"
  end
end
