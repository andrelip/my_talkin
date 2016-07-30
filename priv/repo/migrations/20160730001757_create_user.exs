defmodule Talkin.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :uid, :string
      add :name, :string
      add :oauth_token, :string
      add :oauth_expires_at, :datetime

      timestamps()
    end

  end
end
