# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Parkin.Repo.insert!(%Parkin.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Parkin.{Repo, Billing.Currency, Billing.Rate}

[
  %{id: 1, name: "Parkin Token", code: "TOK"},
  %{id: 2, name: "US Dollar", code: "USD"},
  %{id: 3, name: "Euro", code: "EUR"}
]
|> Enum.map(fn currency_data -> Currency.changeset(%Currency{}, currency_data) end)
|> Enum.each(fn changeset -> Repo.insert!(changeset) end)

[
  %{from_currency_id: 3, to_currency_id: 1, rate: 10},
  %{from_currency_id: 2, to_currency_id: 1, rate: 10}
]
|> Enum.map(fn rate_data -> Rate.changeset(%Rate{}, rate_data) end)
|> Enum.each(fn changeset -> Repo.insert!(changeset) end)
