defmodule Parkin.Billing.Currency do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :id, autogenerate: false}

  schema "currencies" do
    field :name, :string
    field :code, :string

    timestamps()
  end

  @doc false
  def changeset(currency, attrs) do
    currency
    |> cast(attrs, [:name, :code])
    |> validate_required([:name, :code])
  end
end
