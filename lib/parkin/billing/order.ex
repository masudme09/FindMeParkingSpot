defmodule Parkin.Billing.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    belongs_to :user, Parkin.Accounts.User
    belongs_to :service, Parkin.Sales.Service
    # field :type, :string
    # field :amount, :integer
    # field :price, :integer
    ## belongs_to :currency, Parkin.Billing.Currency
    # field :start, :utc_datetime
    # field :end, :utc_datetime
    belongs_to :payment, Parkin.Billing.Payment
    field :loc_lat_long, :string
    field :comment, :string
    field :status, :string

    has_many :parkings, Parkin.Sales.Parking
    # has_many :payments, Parkin.Billing.Payment

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:loc_lat_long, :comment, :status])
    |> cast_assoc(:user)
    |> cast_assoc(:service)
    |> cast_assoc(:payment)
    |> cast_assoc(:parkings)
    # |> cast_assoc(:currency)
    |> validate_required([:loc_lat_long])
  end
end
