defmodule Talkin.Repo.Migrations.CreateRoom do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :token, :string, size: 16
      add :private, :boolean, default: false, null: false
      add :key, :string
      add :location, :geometry

      timestamps()
    end

  end
end
