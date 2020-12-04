defmodule Parkin.Repo.Migrations.CreateRates do
  use Ecto.Migration

  def change do
    create table(:rates) do
      add :from_currency_id, references(:currencies)
      add :to_currency_id, references(:currencies)
      add :rate, :integer

      timestamps()
    end
  end
end
