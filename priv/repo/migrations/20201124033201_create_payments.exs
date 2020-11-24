defmodule Parkin.Repo.Migrations.CreatePayments do
  use Ecto.Migration

  def change do
    create table(:payments) do
      add :order_id, references(:orders)
      add :user_id, references(:users)
      add :currency_id, references(:currencies)
      add :amount, :integer
      add :status, :string
      add :confirmations, :integer

      timestamps()
    end
  end
end
