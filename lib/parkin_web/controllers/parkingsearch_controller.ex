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
    res = Enum.filter(list_of_dest_distance,fn x ->
      [_zone,_location_name,avail,_total,_lat_long,distance] = x
      if avail != 0 and distance < "1.0" do x end
    end)
    case {:ok , Parkin.Helper.Summary.empty?(res)}  do

      {:ok, false} ->
        render(conn |> put_flash(:info, "Available Parking spaces"), "summary.html", query: res, keyword_searched: keyword_searched)

      {:ok, true} ->
        render(conn |> put_flash(:error, "No available Parking spaces"), "summary.html", query: res, keyword_searched: keyword_searched)
    end

  end

  @spec summary_details(Plug.Conn.t(), any) :: Plug.Conn.t()
  def summary_details(conn,params) do
    placename = get_in(params, ["placename"])
    lat_long = get_in(params, ["latlong"])
    distance = get_in(params, ["dist"])
    payment_summary = Summary.get_zone_payment_data_from(lat_long)
    render(conn |> put_flash(:info, "Parking summary"), "summarydetails.html",payment_summary: payment_summary, placename: placename, distance: distance  )
  end

  def create(conn, _params) do
    conn
    |> put_flash(:info, "Available Parking spaces")
    |> redirect(to: Routes.parkingsearch_path(conn, :search))
  end
end
