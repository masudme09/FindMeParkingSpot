defmodule Parkin.Repo.Migrations.CreateServices do
  use Ecto.Migration

  def change do
    create table(:services) do
      add :name, :string
      add :desc, :string
      add :zone, :string
      add :type, :string, default: "realtime"
      add :duration, :integer
      add :price, :integer
      # add :currency_id, references(:currencies)
      add :status, :string

      timestamps()
    end
  end
end
