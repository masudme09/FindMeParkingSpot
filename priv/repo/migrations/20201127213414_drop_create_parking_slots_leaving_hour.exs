defmodule Parkin.Repo.Migrations.DropCreateParkingSlotsLeavingHour do
  use Ecto.Migration

  def change do
    alter table(:parking_slots) do
      remove :leaving_hour, :time

    end

  end
end
