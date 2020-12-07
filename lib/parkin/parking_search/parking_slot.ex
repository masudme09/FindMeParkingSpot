defmodule Parkin.ParkingSearch.ParkingSlot do
  use Ecto.Schema
  import Ecto.Changeset

  schema "parking_slots" do
    field :available_slots, :integer
    field :reserved_slots, :integer
    field :loc_lat_long, :string
    field :parking_place, :string
    field :total_slots, :integer
    field :zone, :string
    field :lock, :integer
    field :slot_buffer, :integer

    timestamps()
  end

  @doc false
  def changeset(parking_slot, attrs \\ %{}) do
    parking_slot
    |> cast(attrs, [
      :parking_place,
      :loc_lat_long,
      :zone,
      :total_slots,
      :reserved_slots,
      :available_slots,
      :lock,
      :slot_buffer
    ])
    |> validate_required([
      :parking_place,
      :loc_lat_long,
      :zone,
      :total_slots,
      :reserved_slots,
      :available_slots
    ])
    |> unique_constraint(:loc_lat_long)
  end
end
