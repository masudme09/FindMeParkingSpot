defmodule Parkin.Repo.Migrations.CreatePayments do
  use Ecto.Migration

  def change do
    create table(:payments) do
      add :user_id, references(:users)
      # add :order_id, references(:orders)
      # add :currency_id, references(:currencies)
      add :amount, :integer
      add :status, :string, default: "created"

      timestamps()
    end
  end
end
