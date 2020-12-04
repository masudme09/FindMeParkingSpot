defmodule ParkinWeb.ParkingSlotController do
  use ParkinWeb, :controller

  alias Parkin.ParkingSearch
  alias Parkin.ParkingSearch.ParkingSlot

  def index(conn, _params) do
    parking_slots = ParkingSearch.list_parking_slots()
    render(conn, "index.html", parking_slots: parking_slots)
  end

  def new(conn, _params) do
    changeset = ParkingSearch.change_parking_slot(%ParkingSlot{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"parking_slot" => parking_slot_params}) do
    case ParkingSearch.create_parking_slot(parking_slot_params) do
      {:ok, parking_slot} ->
        conn
        |> put_flash(:info, "Parking slot created successfully.")
        |> redirect(to: Routes.parking_slot_path(conn, :show, parking_slot))
      
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    parking_slot = ParkingSearch.get_parking_slot!(id)
    render(conn, "show.html", parking_slot: parking_slot)
  end

  def edit(conn, %{"id" => id}) do
    parking_slot = ParkingSearch.get_parking_slot!(id)
    changeset = ParkingSearch.change_parking_slot(parking_slot)
    render(conn, "edit.html", parking_slot: parking_slot, changeset: changeset)
  end

  def update(conn, %{"id" => id, "parking_slot" => parking_slot_params}) do
    parking_slot = ParkingSearch.get_parking_slot!(id)

    case ParkingSearch.update_parking_slot(parking_slot, parking_slot_params) do
      {:ok, parking_slot} ->
        conn
        |> put_flash(:info, "Parking slot updated successfully.")
        |> redirect(to: Routes.parking_slot_path(conn, :show, parking_slot))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", parking_slot: parking_slot, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    parking_slot = ParkingSearch.get_parking_slot!(id)
    {:ok, _parking_slot} = ParkingSearch.delete_parking_slot(parking_slot)

    conn
    |> put_flash(:info, "Parking slot deleted successfully.")
    |> redirect(to: Routes.parking_slot_path(conn, :index))
  end
end
