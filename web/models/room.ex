defmodule Talkin.Room do
  use Talkin.Web, :model
  alias Talkin.Repo

  schema "rooms" do
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
    |> cast(params, [:token, :private, :key, :location])
    |> validate_required([:token, :private, :key, :location])
  end

  def list do
    Repo.all(Talkin.Room)
  end
end
