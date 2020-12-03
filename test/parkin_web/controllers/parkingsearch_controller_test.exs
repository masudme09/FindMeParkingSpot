defmodule ParkinWeb.ParkingSearchControllerTest do
  use ParkinWeb.ConnCase

  test "Get /availableparkings", %{conn: conn} do
    conn = get conn, "/parking/search", %{searchtext: "Veski"}
    conn = post(conn, Routes.parkingsearch_path(conn, :summary), searchtext: "Veski")
    assert html_response(conn, 200) =~ "Available Parking spaces"
  end

end
