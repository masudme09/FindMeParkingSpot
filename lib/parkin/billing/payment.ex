defmodule Parkin.Billing.Payment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "payments" do
    belongs_to :user, Parkin.Accounts.User
    # belongs_to :currency, Parkin.Billing.Currency
    field :amount_to_pay, :integer, virtual: true
    field :amount, :integer
    field :status, :string
    field :virt_order_id, :integer, virtual: true

    has_many :orders, Parkin.Billing.Order

    timestamps()
  end

  @doc false
  def changeset(payment, attrs) do
    payment
    |> cast(attrs, [:amount, :amount_to_pay, :status])
    |> cast_assoc(:user)
    |> cast_assoc(:orders)
    # |> cast_assoc(:currency)
    |> validate_required([:amount])
  end
end
