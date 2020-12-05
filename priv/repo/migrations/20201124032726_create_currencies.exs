defmodule Parkin.Repo.Migrations.CreateCurrencies do
  use Ecto.Migration

  def change do
    create table(:currencies) do
      add :name, :string
      add :code, :string

      timestamps()
    end

    create unique_index(:currencies, [:name, :code])
  end
end
