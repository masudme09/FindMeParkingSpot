defmodule Parkin.Repo.Migrations.UpdateUserWithLicenseNumber do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :license_number, :string
    end
  end
end
