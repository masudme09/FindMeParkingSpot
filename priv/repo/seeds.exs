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

alias Parkin.{
  Repo,
  Accounts.User,
  ParkingSearch.ParkingSlot,
  ParkingSearch.Pricing,
  Billing.Currency,
  Billing.Rate,
  Sales.Service
}

[
  %{zone: "A", hourly: "2", realtime: "16"},
  %{zone: "B", hourly: "1", realtime: "8"}
]
|> Enum.map(fn zone_data -> Pricing.changeset(%Pricing{}, zone_data) end)
|> Enum.each(fn changeset -> Repo.insert!(changeset) end)

[
  %{
    parking_place: "Veski",
    loc_lat_long: "58.37801,26.711",
    zone: "A",
    total_slots: 200,
    available_slots: 5
  },
  %{
    parking_place: "Kastani",
    loc_lat_long: "58.37908,26.70908",
    zone: "A",
    total_slots: 200,
    available_slots: 5
  },
  %{
    parking_place: "Kooli",
    loc_lat_long: "58.37799,26.70736",
    zone: "A",
    total_slots: 200,
    available_slots: 5
  },
  %{
    parking_place: "Lossi",
    loc_lat_long: "58.37927,26.71754",
    zone: "B",
    total_slots: 200,
    available_slots: 5
  },
  %{
    parking_place: "Ülikooli",
    loc_lat_long: "58.37906,26.72253",
    zone: "B",
    total_slots: 200,
    available_slots: 5
  },
  %{
    parking_place: "Küüni",
    loc_lat_long: "58.37875,26.72456",
    zone: "B",
    total_slots: 200,
    available_slots: 5
  }
]
|> Enum.map(fn parking_data -> ParkingSlot.changeset(%ParkingSlot{}, parking_data) end)
|> Enum.each(fn changeset -> Repo.insert!(changeset) end)

# alias Parkin.Geolocation
# Geolocation.distance("Kastani, Tartu, Tartu maakond 51005, Eesti","Veski, Tartu, Tartu maakond 50409, Eesti")
# Geolocation.find_location("Kastani, Tartu, Tartu maakond 51005, Eesti")
# Geolocation.probable_distance("58.37801, 26.711","58.37801, 26.711")

# Kastani, Tartu, Tartu maakond 51005, Eesti
# Veski, Tartu, Tartu maakond 50409, Eesti
# Kooli, Tartu, Tartu maakond 50409, Eesti

# Lossi, Tartu, Tartu maakond 50093, Eesti
# Ülikooli, Tartu, Tartu maakond 51001, Eesti
# Küüni, Tartu, Tartu maakond 50099, Eesti
# mix run priv/repo/seeds.exs

# [
#   %{id: 1, name: "Parkin Token", code: "TOK"},
#   %{id: 2, name: "US Dollar", code: "USD"},
#   %{id: 3, name: "Euro", code: "EUR"}
# ]
# |> Enum.map(fn currency_data -> Currency.changeset(%Currency{}, currency_data) end)
# |> Enum.each(fn changeset -> Repo.insert!(changeset) end)

[
  %{
    name: "Real Time",
    desc: "Real Time Parking",
    type: "realtime",
    duration: 1,
    price: 1,
    # currency: "TOK",
    status: "active"
  },
  %{
    name: "Hourly",
    desc: "Hourly Parking Service",
    type: "hourly",
    duration: 60,
    price: 50,
    # currency: "TOK",
    status: "active"
  }
  # %{
  #   name: "EPM",
  #   desc: "EUR / Minute Parking",
  #   price: 3,
  #   # currency: "TOK",
  #   status: "active"
  # },
  # %{
  #   name: "EPH",
  #   desc: "EUR / Hour Parking",
  #   price: 150,
  #   currency: "TOK",
  #   status: "active"
  # },
  # %{
  #   name: "UPM",
  #   desc: "USD / Minute Parking",
  #   price: 4,
  #   currency: "TOK",
  #   status: "active"
  # },
  # %{
  #   name: "UPH",
  #   desc: "USD / Hour Parking",
  #   price: 200,
  #   currency: "TOK",
  #   status: "active"
  # },
  # %{
  #   name: "EPT",
  #   desc: "EUR / TOK",
  #   price: 2,
  #   currency: "EUR",
  #   status: "active"
  # },
  # %{
  #   name: "UPT",
  #   desc: "USD / TOK",
  #   price: 3,
  #   currency: "USD",
  #   status: "active"
  # }
]
|> Enum.each(fn data ->
  %Service{
    name: data[:name],
    desc: data[:desc],
    type: data[:type],
    duration: data[:duration],
    price: data[:price],
    # currency: Repo.get_by(Currency, code: data[:currency]),
    status: data[:status]
  }
  |> Repo.insert!()
end)

# [
#   %{currency_from: "EUR", currency_to: "TOK", rate: 10},
#   %{currency_from: "USD", currency_to: "TOK", rate: 9}
# ]
# |> Enum.each(fn data ->
#   %Rate{
#     rate: data[:rate],
#     currency_from: Repo.get_by(Currency, code: data[:currency_from]),
#     currency_to: Repo.get_by(Currency, code: data[:currency_to])
#   }
#   |> Repo.insert!()
# end)
