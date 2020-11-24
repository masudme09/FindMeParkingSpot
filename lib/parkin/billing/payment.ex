defmodule Parkin.Billing.Payment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "payments" do

    timestamps()
  end

  @doc false
  def changeset(payment, attrs) do
    payment
    |> cast(attrs, [])
    |> validate_required([])
  end
end
