defmodule ParkinWeb.ParkingControllerTest do
  use ParkinWeb.ConnCase

  alias Parkin.Sales

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:parking) do
    {:ok, parking} = Sales.create_parking(@create_attrs)
    parking
  end

  describe "index" do
    test "lists all parkings", %{conn: conn} do
      conn = get(conn, Routes.parking_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Parkings"
    end
  end

  describe "new parking" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.parking_path(conn, :new))
      assert html_response(conn, 200) =~ "New Parking"
    end
  end

  describe "create parking" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.parking_path(conn, :create), parking: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.parking_path(conn, :show, id)

      conn = get(conn, Routes.parking_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Parking"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.parking_path(conn, :create), parking: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Parking"
    end
  end

  describe "edit parking" do
    setup [:create_parking]

    test "renders form for editing chosen parking", %{conn: conn, parking: parking} do
      conn = get(conn, Routes.parking_path(conn, :edit, parking))
      assert html_response(conn, 200) =~ "Edit Parking"
    end
  end

  describe "update parking" do
    setup [:create_parking]

    test "redirects when data is valid", %{conn: conn, parking: parking} do
      conn = put(conn, Routes.parking_path(conn, :update, parking), parking: @update_attrs)
      assert redirected_to(conn) == Routes.parking_path(conn, :show, parking)

      conn = get(conn, Routes.parking_path(conn, :show, parking))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, parking: parking} do
      conn = put(conn, Routes.parking_path(conn, :update, parking), parking: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Parking"
    end
  end

  describe "delete parking" do
    setup [:create_parking]

    test "deletes chosen parking", %{conn: conn, parking: parking} do
      conn = delete(conn, Routes.parking_path(conn, :delete, parking))
      assert redirected_to(conn) == Routes.parking_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.parking_path(conn, :show, parking))
      end
    end
  end

  defp create_parking(_) do
    parking = fixture(:parking)
    %{parking: parking}
  end
end
