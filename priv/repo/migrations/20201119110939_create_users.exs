defmodule Parkin.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :username, :string
      add :hashed_password, :string

      timestamps()
    end

    create unique_index(:users, [:username])
  end
end
