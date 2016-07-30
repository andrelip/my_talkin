defmodule Talkin.Room do
  use Talkin.Web, :model
  alias Talkin.Repo

  schema "rooms" do
    field :name, :string
    field :token, :string
    field :private, :boolean, default: false
    field :key, :string
    field :location, Geo.Geometry

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :token, :private, :key, :location])
    |> validate_required([:name, :token, :location])
  end

  def list do
    Repo.all(Talkin.Room)
  end

  def list_as_json do
    list
    |> Enum.map(&(Talkin.User.take_from_list(&1)))
    |> Poison.encode!
  end

  def take_public_info(item) do
    Map.take(item, [:token, :private, :location])
  end

  def list_as_json do
    list
    |> Enum.map(&(Talkin.User.take_from_list(&1)))
    |> Poison.encode!
  end
end
