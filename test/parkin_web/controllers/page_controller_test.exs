defmodule ParkinWeb.PageControllerTest do
  use ParkinWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")

    assert html_response(conn, 200) =~
             "ParkIn - Tartu! Parking solutions for the Digital Generation"
  end
end
