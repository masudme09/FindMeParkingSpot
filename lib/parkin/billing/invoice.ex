defmodule Parkin.Billing.Invoice do
  use Ecto.Schema
  import Ecto.Changeset

  schema "invoices" do

    timestamps()
  end

  @doc false
  def changeset(invoice, attrs) do
    invoice
    |> cast(attrs, [])
    |> validate_required([])
  end
end
