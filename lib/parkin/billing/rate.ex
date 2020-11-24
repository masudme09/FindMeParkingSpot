defmodule Parkin.Billing.Rate do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rates" do
    belongs_to :from_currency, Parkin.Billing.Currency, source: :from_currency_id
    belongs_to :to_currency, Parkin.Billing.Currency, source: :to_currency_id
    field :rate, :integer

    timestamps()
  end

  @doc false
  def changeset(rate, attrs) do
    rate
    |> cast(attrs, [:rate])
    |> cast_assoc(:from_currency)
    |> cast_assoc(:to_currency)
    |> validate_required([:from_currency, :to_currency, :rate])
  end
end
