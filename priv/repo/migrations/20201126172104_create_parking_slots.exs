defmodule Parkin.Repo.Migrations.CreateParkingSlots do
  use Ecto.Migration

  def change do
    create table(:parking_slots) do
      add :parking_place, :string
      add :loc_lat_long, :string
      add :zone, :string
      add :total_slots, :integer
      add :available_slots, :integer

      timestamps()
    end

    create unique_index(:parking_slots, [:loc_lat_long])
  end
end
