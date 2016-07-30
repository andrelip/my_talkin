defmodule Talkin.UserSessionTest do
  use Talkin.ModelCase

  alias Talkin.UserSession

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = UserSession.changeset(%UserSession{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = UserSession.changeset(%UserSession{}, @invalid_attrs)
    refute changeset.valid?
  end
end
