defmodule Parkin.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :user_id, references(:users)
      add :service_id, references(:services)
      # add :type, :string, default: "realtime"
      # add :amount, :integer
      # add :price, :integer
      # add :start, :utc_datetime
      # add :end, :utc_datetime
      ## add :currency_id, references(:currencies)
      add :payment_id, references(:payments)
      add :comment, :string, default: "Parking"
      add :status, :string, default: "created"

      timestamps()
    end
  end
end
