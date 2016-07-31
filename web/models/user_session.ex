defmodule Talkin.UserSession do
  use Talkin.Web, :model
  alias Talkin.Repo
  import Ecto.Query

  schema "user_sessions" do
    belongs_to :user, Talkin.User
    field :location, Geo.Geometry

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :location])
    |> validate_required([:user_id, :location])
  end

  def last_location(user) do
    query = from session in Talkin.UserSession,
            where: session.user_id == ^user.id,
            select: session.location
    query |> last(:inserted_at) |> Repo.one
  end
end
