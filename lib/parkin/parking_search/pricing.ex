defmodule Parkin.ParkingSearch.Pricing do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pricing" do
    field :zone, :string
    field :hourly, :integer
    field :realtime, :integer


    timestamps()
  end

  @doc false
  def changeset(pricing, attrs) do
    pricing
    |> cast(attrs, [:zone, :hourly, :realtime])
  end
end
