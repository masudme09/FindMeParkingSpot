defmodule Parkin.Repo.Migrations.AddPaidStatusToOrders do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      add :payment_status, :string
    end
  end
end
