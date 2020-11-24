defmodule Parkin.Repo.Migrations.CreateInvoices do
  use Ecto.Migration

  def change do
    create table(:invoices) do

      timestamps()
    end

  end
end
