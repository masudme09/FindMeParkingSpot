defmodule Parkin.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :user_id, references(:users)
      add :type, :string
      add :currency_id, references(:currencies)
      add :amount, :integer
      add :status, :string

      timestamps()
    end
  end
end
