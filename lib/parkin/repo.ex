defmodule Parkin.Repo do
  use Ecto.Repo,
    otp_app: :parkin,
    adapter: Ecto.Adapters.Postgres
end
