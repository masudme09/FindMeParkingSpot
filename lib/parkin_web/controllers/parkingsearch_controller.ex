defmodule ParkinWeb.ParkingsearchController do
  use ParkinWeb, :controller
  alias Parkin.Helper.Summary

  def search(conn, _params) do
    render(conn, "search.html")
  end

  def summary(conn, params) do
    keyword_searched = get_in(params, ["searchtext"])
    lat_long = Summary.get_lat_long_of_dest_address(keyword_searched)
    list_of_place_lat_long = Summary.list_of_all_lat_long()
    list_of_dest_distance = Summary.distance_between(lat_long,list_of_place_lat_long)
    render(conn |> put_flash(:info, "Available Parking spaces"), "summary.html", query: list_of_dest_distance, keyword_searched: keyword_searched)
  end

  def summary_details(conn,params) do
    placename = get_in(params, ["placename"])
    lat_long = get_in(params, ["latlong"])
    distance = get_in(params, ["dist"])
    payment_summary = Summary.get_zone_payment_data_from(lat_long)
    render(conn |> put_flash(:info, "Parking summary"), "summarydetails.html",payment_summary: payment_summary, placename: placename, distance: distance  )
  end

end
