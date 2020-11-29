defmodule ParkinWeb.ParkingsearchController do
  use ParkinWeb, :controller
  alias Parkin.Repo

  alias Parkin.ParkingSearch.ParkingSlot
  alias Parkin.Helper.Summary
  import Ecto.Query, only: [from: 2]

  def search(conn, _params) do
    render(conn, "search.html")
  end

  def summary(conn, params) do
    keyword_searched = get_in(params, ["searchtext"])
    lat_long = Summary.get_lat_long_of_dest_address(keyword_searched)
    list_of_place_lat_long = Summary.list_of_all_lat_long()
    list_of_dest_distance = Summary.distance_between(lat_long,list_of_place_lat_long)
    render(conn |> put_flash(:info, "Parking spaces"), "summary.html", query: list_of_dest_distance, keyword_searched: keyword_searched)
  end




end
