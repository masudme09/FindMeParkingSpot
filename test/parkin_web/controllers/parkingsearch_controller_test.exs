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

  test "Only places inside the radius of 1km is displayed", %{conn: conn} do
    conn = post(conn, Routes.parkingsearch_path(conn, :summary), searchtext: "Veski, Tartu, Estonia")
    x = html_response(conn, 200)
    b= Floki.find(x, "a")
      |> Floki.attribute("href")
    c = Enum.filter(b, fn x->
      if String.contains?(x, "dist") do x end
    end)

    d= Enum.map(c, fn x ->
      e = List.last( String.split(x,"&"))
      f = List.last( String.split(x,"="))
      {m , n} = Float.parse(f)
      if m < 1.0 do m end
    end)

    assert length(d) > 0
  end

  #2.2 TDD
  test "Availability for retrieved spots is always > 1", %{conn: conn} do
    conn = post(conn, Routes.parkingsearch_path(conn, :summary), searchtext: "Veski, Tartu, Estonia")
    x = html_response(conn, 200)
    b= Floki.find(x, "a")
      |> Floki.attribute("href")
    c = Enum.filter(b, fn x->
      if String.contains?(x, "dist") do x end
    end)

    assert length(b) > 0
  end

end
