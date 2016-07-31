defmodule Talkin.User do
  use Talkin.Web, :model
  alias Talkin.Repo

  schema "users" do
    field :uid, :string
    field :name, :string
    field :oauth_token, :string
    field :token, :string
    field :oauth_expires_at, Ecto.DateTime
    has_many :sessions, Talkin.UserSession

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:uid, :name, :oauth_token, :oauth_expires_at])
    |> validate_required([:uid, :name, :oauth_token])
    |> put_change(:token, random_token)
  end

  def list do
    Repo.all(Talkin.User)
  end

  def list_as_json do
    list
    |> Enum.map(&(Talkin.User.take_public_info(&1)))
    |> Poison.encode!
  end

  def take_public_info(item) do
      Map.take(item, [:uid, :name])
  end

  defp random_token do
    SecureRandom.urlsafe_base64(16) |> String.slice(1..16)
  end
end
