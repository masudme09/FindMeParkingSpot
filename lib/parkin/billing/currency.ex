defmodule Parkin.Billing.Currency do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :id, autogenerate: false}

  schema "currencies" do
    field :name, :string
    field :code, :string

    has_many :rates_from, Parkin.Billing.Rate, foreign_key: :currency_from_id
    has_many :rates_to, Parkin.Billing.Rate, foreign_key: :currency_to_id

    timestamps()
  end

  @doc false
  def changeset(currency, attrs) do
    currency
    |> cast(attrs, [:name, :code])
    |> cast_assoc(:rates_from)
    |> cast_assoc(:rates_to)
    |> validate_required([:name, :code])
  end
end
