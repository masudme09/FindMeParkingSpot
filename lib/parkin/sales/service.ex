defmodule Parkin.Sales.Service do
  use Ecto.Schema
  import Ecto.Changeset

  schema "services" do
    field :name, :string
    field :desc, :string
    field :zone, :string
    field :type, :string
    field :duration, :integer
    field :price, :integer
    # belongs_to :currency, Parkin.Billing.Currency
    field :status, :string

    has_many :parkings, Parkin.Sales.Parking
    has_many :orders, Parkin.Billing.Order

    timestamps()
  end

  @doc false
  def changeset(service, attrs) do
    service
    |> cast(attrs, [:name, :desc, :zone, :type, :duration, :price, :status])
    # |> cast_assoc(:currency)
    |> validate_required([:name, :desc, :zone, :type, :price, :duration, :status])
  end
end
