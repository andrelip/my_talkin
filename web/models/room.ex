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
    |> cast(params, [:name, :private, :key, :location])
    |> validate_required([:name])
    |> put_change(:token, generate_token)
  end

  def list do
    Repo.all(Talkin.Room)
  end

  def list_as_json do
    list
    |> Enum.map(&(Talkin.Room.take_public_info(&1)))
    |> Poison.encode!
  end

  def display_as_json(room) do
    room
    |> take_public_info
    |> Poison.encode!
  end

  def take_public_info(item) do
    Map.take(item, [:name, :token, :private, :location])
    |> Map.drop([:location])
    |> Map.put(:location, Geo.JSON.encode(item.location))
  end

  defp generate_token do
    SecureRandom.urlsafe_base64(16) |> String.slice(1..16)
  end
end
