defmodule Parkin.Repo.Migrations.CreatePricing do
  use Ecto.Migration

  def change do
    create table(:pricing) do
      add :zone, :string
      add :hourly, :integer
      add :realtime, :integer

      timestamps()
    end

  end
end
