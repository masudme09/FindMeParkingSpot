defmodule Parkin.Repo.Migrations.AddReservedSlotsToParkingSlot do
  use Ecto.Migration

  def change do
    alter table(:parking_slots) do
      add :reserved_slots, :integer
      add :lock, :integer
      add :slot_buffer, :integer
    end
  end
end
