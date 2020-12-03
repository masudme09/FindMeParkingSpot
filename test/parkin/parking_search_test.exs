defmodule Parkin.ParkingSearchTest do
  use Parkin.DataCase

  alias Parkin.ParkingSearch

  describe "parking_slots" do
    alias Parkin.ParkingSearch.ParkingSlot

    @valid_attrs %{available_slots: 200, loc_lat_long: "58.37799,26.70736", parking_place: "Kooli", total_slots: 200, zone: "A"}
    @update_attrs %{available_slots: 200, loc_lat_long: "58.37799,26.70736", parking_place: "Kooli", total_slots: 200, zone: "A"}
    @invalid_attrs %{available_slots: nil, loc_lat_long: nil, parking_place: nil, total_slots: nil, zone: nil}

    def parking_slot_fixture(attrs \\ %{}) do
      {:ok, parking_slot} =
        attrs
        |> Enum.into(@valid_attrs)
        |> ParkingSearch.create_parking_slot()

      parking_slot
    end

    test "list_parking_slots/0 returns all parking_slots" do
      parking_slot = parking_slot_fixture()
      assert ParkingSearch.list_parking_slots() == [parking_slot]
    end

    test "get_parking_slot!/1 returns the parking_slot with given id" do
      parking_slot = parking_slot_fixture()
      assert ParkingSearch.get_parking_slot!(parking_slot.id) == parking_slot
    end

    test "create_parking_slot/1 with valid data creates a parking_slot" do
      assert {:ok, %ParkingSlot{} = parking_slot} = ParkingSearch.create_parking_slot(@valid_attrs)
      assert parking_slot.available_slots == 200
      assert parking_slot.loc_lat_long == "58.37799,26.70736"
      assert parking_slot.parking_place == "Kooli"
      assert parking_slot.total_slots == 200
      assert parking_slot.zone == "A"
    end

    test "create_parking_slot/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ParkingSearch.create_parking_slot(@invalid_attrs)
    end

    test "update_parking_slot/2 with valid data updates the parking_slot" do
      parking_slot = parking_slot_fixture()
      assert {:ok, %ParkingSlot{} = parking_slot} = ParkingSearch.update_parking_slot(parking_slot, @update_attrs)
      assert parking_slot.available_slots == 200
      assert parking_slot.loc_lat_long == "58.37799,26.70736"
      assert parking_slot.parking_place == "Kooli"
      assert parking_slot.total_slots == 200
      assert parking_slot.zone == "A"
    end

    test "update_parking_slot/2 with invalid data returns error changeset" do
      parking_slot = parking_slot_fixture()
      assert {:error, %Ecto.Changeset{}} = ParkingSearch.update_parking_slot(parking_slot, @invalid_attrs)
      assert parking_slot == ParkingSearch.get_parking_slot!(parking_slot.id)
    end

    test "delete_parking_slot/1 deletes the parking_slot" do
      parking_slot = parking_slot_fixture()
      assert {:ok, %ParkingSlot{}} = ParkingSearch.delete_parking_slot(parking_slot)
      assert_raise Ecto.NoResultsError, fn -> ParkingSearch.get_parking_slot!(parking_slot.id) end
    end

    test "change_parking_slot/1 returns a parking_slot changeset" do
      parking_slot = parking_slot_fixture()
      assert %Ecto.Changeset{} = ParkingSearch.change_parking_slot(parking_slot)
    end
  end
end
