defmodule Talkin.Repo.Migrations.AddFieldsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :token, :string, size: 16
    end
    create index(:users, [:token], unique: true)
  end
end
