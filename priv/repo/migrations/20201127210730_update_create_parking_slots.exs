defmodule Parkin.Repo.Migrations.UpdateCreateParkingSlots do
  use Ecto.Migration

  def change do
    alter table(:parking_slots) do
      add :leaving_hour, :time

    end

  end
end
