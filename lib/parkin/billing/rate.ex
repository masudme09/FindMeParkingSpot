defmodule Parkin.Billing.Rate do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rates" do
    field :rate, :integer

    belongs_to :currency_from, Parkin.Billing.Currency
    belongs_to :currency_to, Parkin.Billing.Currency

    timestamps()
  end

  @doc false
  def changeset(rate, attrs) do
    rate
    |> cast(attrs, [:rate])
    |> cast_assoc(:currency_from)
    |> cast_assoc(:currency_to)
    |> validate_required([:currency_from, :currency_to, :rate])
  end
end
