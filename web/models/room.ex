defmodule Talkin.Room do
  use Talkin.Web, :model

  schema "rooms" do
    field :token, :string
    field :private, :boolean, default: false
    field :key, :string
    # field :location, :geometry

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:token, :private, :key])
    |> validate_required([:token, :private, :key])
  end
end
