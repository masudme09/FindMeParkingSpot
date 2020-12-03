defmodule ParkinWeb.ParkingSearchControllerTest do
  use ParkinWeb.ConnCase

  #2.1 TDD
  test "Get /availableparkings", %{conn: conn} do
    conn = get conn, "/parking/search", %{searchtext: "Veski, Tartu, Estonia"}
    conn = post(conn, Routes.parkingsearch_path(conn, :summary), searchtext: "Veski, Tartu, Estonia")
    assert html_response(conn, 200) =~ "Available Parking spaces"
  end

  test "No available parking space due to radius", %{conn: conn} do
    conn = get conn, "/parking/search", %{searchtext: "Talli, 62222 Luunja Parish, Eesti"}
    conn = post(conn, Routes.parkingsearch_path(conn, :summary), searchtext: "Talli, 62222 Luunja Parish, Eesti")
    assert html_response(conn, 200) =~ "No available Parking spaces"
  end

end
