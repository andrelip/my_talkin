defmodule Talkin.Repo.Migrations.CreateUserSession do
  use Ecto.Migration

  def change do
    create table(:user_sessions) do
      add :user_id, references(:users, on_delete: :nothing)
      add :location, :geometry

      timestamps()
    end
    create index(:user_sessions, [:user_id])

  end
end
