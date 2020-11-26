defmodule Parkin.ParkingSearch.ParkingSlot do
  use Ecto.Schema
  import Ecto.Changeset

  schema "parking_slots" do
    field :available_slots, :integer
    field :loc_lat_long, :string
    field :parking_place, :string
    field :total_slots, :integer
    field :zone, :string

    timestamps()
  end

  @doc false
  def changeset(parking_slot, attrs) do
    parking_slot
    |> cast(attrs, [:parking_place, :loc_lat_long, :zone, :total_slots, :available_slots])
    |> validate_required([:parking_place, :loc_lat_long, :zone, :total_slots, :available_slots])
    |> unique_constraint(:loc_lat_long)
  end
end
