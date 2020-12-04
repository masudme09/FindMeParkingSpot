defmodule Parkin.Repo.Migrations.AddTokensToUsersTable do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :tokens, :integer, default: 1000
      add :type, :string, default: "default"
      # or "monthly"
    end
  end
end
