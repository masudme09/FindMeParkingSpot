defmodule Parkin.Billing.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    belongs_to :user, Parkin.Accounts.User
    field :type, :string
    belongs_to :currency, Parkin.Billing.Currency
    field :amount, :integer
    field :status, :integer

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:type, :amount])
    |> validate_required([:type, :amount])
  end
end
