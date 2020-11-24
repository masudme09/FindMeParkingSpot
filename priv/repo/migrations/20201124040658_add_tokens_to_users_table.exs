defmodule Parkin.Repo.Migrations.AddTokensToUsersTable do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :tokens, :integer
      add :token_buffer, :integer
    end
  end
end
