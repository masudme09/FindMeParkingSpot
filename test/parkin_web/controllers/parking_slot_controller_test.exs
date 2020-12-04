defmodule ParkinWeb.ParkingSlotControllerTest do
  use ParkinWeb.ConnCase

  alias Parkin.ParkingSearch

  @create_attrs %{available_slots: 42, loc_lat_long: "some loc_lat_long", parking_place: "some parking_place", total_slots: 42, zone: "some zone"}
  @update_attrs %{available_slots: 43, loc_lat_long: "some updated loc_lat_long", parking_place: "some updated parking_place", total_slots: 43, zone: "some updated zone"}
  @invalid_attrs %{available_slots: nil, loc_lat_long: nil, parking_place: nil, total_slots: nil, zone: nil}

  def fixture(:parking_slot) do
    {:ok, parking_slot} = ParkingSearch.create_parking_slot(@create_attrs)
    parking_slot
  end

  describe "index" do
    test "lists all parking_slots", %{conn: conn} do
      conn = get(conn, Routes.parking_slot_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Parking slots"
    end
  end

  describe "new parking_slot" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.parking_slot_path(conn, :new))
      assert html_response(conn, 200) =~ "New Parking slot"
    end
  end

  describe "create parking_slot" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.parking_slot_path(conn, :create), parking_slot: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.parking_slot_path(conn, :show, id)

      conn = get(conn, Routes.parking_slot_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Parking slot"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.parking_slot_path(conn, :create), parking_slot: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Parking slot"
    end
  end

  describe "edit parking_slot" do
    setup [:create_parking_slot]

    test "renders form for editing chosen parking_slot", %{conn: conn, parking_slot: parking_slot} do
      conn = get(conn, Routes.parking_slot_path(conn, :edit, parking_slot))
      assert html_response(conn, 200) =~ "Edit Parking slot"
    end
  end

  describe "update parking_slot" do
    setup [:create_parking_slot]

    test "redirects when data is valid", %{conn: conn, parking_slot: parking_slot} do
      conn = put(conn, Routes.parking_slot_path(conn, :update, parking_slot), parking_slot: @update_attrs)
      assert redirected_to(conn) == Routes.parking_slot_path(conn, :show, parking_slot)

      conn = get(conn, Routes.parking_slot_path(conn, :show, parking_slot))
      assert html_response(conn, 200) =~ "some updated loc_lat_long"
    end

    test "renders errors when data is invalid", %{conn: conn, parking_slot: parking_slot} do
      conn = put(conn, Routes.parking_slot_path(conn, :update, parking_slot), parking_slot: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Parking slot"
    end
  end

  describe "delete parking_slot" do
    setup [:create_parking_slot]

    test "deletes chosen parking_slot", %{conn: conn, parking_slot: parking_slot} do
      conn = delete(conn, Routes.parking_slot_path(conn, :delete, parking_slot))
      assert redirected_to(conn) == Routes.parking_slot_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.parking_slot_path(conn, :show, parking_slot))
      end
    end
  end

  defp create_parking_slot(_) do
    parking_slot = fixture(:parking_slot)
    %{parking_slot: parking_slot}
  end
end
