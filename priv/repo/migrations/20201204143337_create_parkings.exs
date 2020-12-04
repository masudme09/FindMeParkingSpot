defmodule Parkin.Repo.Migrations.CreateParkings do
  use Ecto.Migration

  def change do
    create table(:parkings) do
      add :user_id, references(:users)
      add :service_id, references(:services)
      add :order_id, references(:orders)
      add :amount, :integer
      add :price, :integer
      add :start, :utc_datetime
      add :end, :utc_datetime

      timestamps()
    end
  end
end
