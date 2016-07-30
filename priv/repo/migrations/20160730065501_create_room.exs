defmodule Talkin.Repo.Migrations.CreateRoom do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :token, :string
      add :private, :boolean, default: false, null: false
      add :key, :string

      timestamps()
    end

  end
end
