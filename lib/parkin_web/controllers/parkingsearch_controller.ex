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
  # <td><%= link "Select", to: Routes.parkingsearch_path(ParkinWeb.Endpoint, :summary_details, key, "latlong": lat_long, "dist": distance), class: "btn btn-default" %> </td>

  def summary_details(conn,params) do
    placename = get_in(params, ["placename"])
    lat_long = get_in(params, ["latlong"])
    distance = get_in(params, ["dist"])
    payment_summary = Summary.get_zone_payment_data_from(lat_long)
    render(conn, "summarydetails.html",payment_summary: payment_summary, placename: placename, distance: distance  )
  end




end
