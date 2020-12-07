defmodule Parkin.Sales.Parking do
  use Ecto.Schema
  import Ecto.Changeset

  schema "parkings" do
    belongs_to :user, Parkin.Accounts.User
    belongs_to :service, Parkin.Sales.Service
    belongs_to :order, Parkin.Billing.Order
    field :amount, :integer
    field :price, :integer
    field :start, :utc_datetime
    field :end, :utc_datetime
    field :slot, :string, virtual: true
    field :type, :string, virtual: true
    field :loc_lat_long, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(parking, attrs) do
    parking
    |> cast(attrs, [:amount, :price, :start, :end, :slot, :type, :loc_lat_long])
    |> cast_assoc(:user)
    |> cast_assoc(:service)
    |> cast_assoc(:order)
    |> validate_required([:start, :end, :type, :loc_lat_long])
  end
end
