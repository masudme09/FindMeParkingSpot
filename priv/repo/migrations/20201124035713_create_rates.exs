defmodule Parkin.Repo.Migrations.CreateRates do
  use Ecto.Migration

  def change do
    create table(:rates) do
      add :rate, :integer
      add :currency_from_id, references(:currencies)
      add :currency_to_id, references(:currencies)

      timestamps()
    end
  end
end
