defmodule Parkin.SalesTest do
  use Parkin.DataCase

  alias Parkin.Sales

  describe "services" do
    alias Parkin.Sales.Service

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def service_fixture(attrs \\ %{}) do
      {:ok, service} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Sales.create_service()

      service
    end

    test "list_services/0 returns all services" do
      service = service_fixture()
      assert Sales.list_services() == [service]
    end

    test "get_service!/1 returns the service with given id" do
      service = service_fixture()
      assert Sales.get_service!(service.id) == service
    end

    test "create_service/1 with valid data creates a service" do
      assert {:ok, %Service{} = service} = Sales.create_service(@valid_attrs)
    end

    test "create_service/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sales.create_service(@invalid_attrs)
    end

    test "update_service/2 with valid data updates the service" do
      service = service_fixture()
      assert {:ok, %Service{} = service} = Sales.update_service(service, @update_attrs)
    end

    test "update_service/2 with invalid data returns error changeset" do
      service = service_fixture()
      assert {:error, %Ecto.Changeset{}} = Sales.update_service(service, @invalid_attrs)
      assert service == Sales.get_service!(service.id)
    end

    test "delete_service/1 deletes the service" do
      service = service_fixture()
      assert {:ok, %Service{}} = Sales.delete_service(service)
      assert_raise Ecto.NoResultsError, fn -> Sales.get_service!(service.id) end
    end

    test "change_service/1 returns a service changeset" do
      service = service_fixture()
      assert %Ecto.Changeset{} = Sales.change_service(service)
    end
  end

  describe "parkings" do
    alias Parkin.Sales.Parking

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def parking_fixture(attrs \\ %{}) do
      {:ok, parking} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Sales.create_parking()

      parking
    end

    test "list_parkings/0 returns all parkings" do
      parking = parking_fixture()
      assert Sales.list_parkings() == [parking]
    end

    test "get_parking!/1 returns the parking with given id" do
      parking = parking_fixture()
      assert Sales.get_parking!(parking.id) == parking
    end

    test "create_parking/1 with valid data creates a parking" do
      assert {:ok, %Parking{} = parking} = Sales.create_parking(@valid_attrs)
    end

    test "create_parking/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sales.create_parking(@invalid_attrs)
    end

    test "update_parking/2 with valid data updates the parking" do
      parking = parking_fixture()
      assert {:ok, %Parking{} = parking} = Sales.update_parking(parking, @update_attrs)
    end

    test "update_parking/2 with invalid data returns error changeset" do
      parking = parking_fixture()
      assert {:error, %Ecto.Changeset{}} = Sales.update_parking(parking, @invalid_attrs)
      assert parking == Sales.get_parking!(parking.id)
    end

    test "delete_parking/1 deletes the parking" do
      parking = parking_fixture()
      assert {:ok, %Parking{}} = Sales.delete_parking(parking)
      assert_raise Ecto.NoResultsError, fn -> Sales.get_parking!(parking.id) end
    end

    test "change_parking/1 returns a parking changeset" do
      parking = parking_fixture()
      assert %Ecto.Changeset{} = Sales.change_parking(parking)
    end
  end
end
