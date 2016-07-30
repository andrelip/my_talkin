defmodule Talkin.User do
  use Talkin.Web, :model

  schema "users" do
    field :uid, :string
    field :name, :string
    field :oauth_token, :string
    field :token, :string
    field :oauth_expires_at, Ecto.DateTime

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

  defp random_token do
    SecureRandom.urlsafe_base64(16) |> String.slice(1..16)
  end
end