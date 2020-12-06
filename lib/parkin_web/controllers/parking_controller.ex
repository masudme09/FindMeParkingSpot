defmodule ParkinWeb.ParkingController do
  use ParkinWeb, :controller

  alias Parkin.Sales
  alias Parkin.Sales.Parking
  alias Parkin.Sales.Service
  alias Parkin.Repo

  def index(conn, _params) do
    parkings = Sales.list_parkings()
    render(conn, "index.html", parkings: parkings)
  end

  # def _get_free_slots(conn, slot) do
  #   slot =
  #     case slot == nil do
  #       true ->
  #         conn
  #         |> put_flash(:error, "Something has gone horribly wrong")
  #         |> redirect(to: Routes.parkingsearch_path(conn, :search))

  #       _ ->
  #         slot
  #     end

  # end

  def new(conn, params) do
    loc_lat_long = params["loc_lat_long"]

    slot =
      case loc_lat_long do
        nil -> nil
        _ -> Repo.get_by(Parkin.ParkingSearch.ParkingSlot, loc_lat_long: loc_lat_long)
      end

    slot =
      case slot == nil do
        true ->
          conn
          |> put_flash(:error, "The selected slot has not been found")
          |> redirect(to: Routes.parkingsearch_path(conn, :search))

        _ ->
          slot
      end

    case slot.reserved_slots + slot.available_slots - slot.total_slots >= slot.slot_buffer do
      true ->
        conn
        |> put_flash(:error, "No free spaces left")
        |> redirect(to: Routes.parkingsearch_path(conn, :search))

      _ ->
        nil
    end

    changeset =
      Sales.change_parking(%Parking{
        type: "realtime",
        slot:
          Enum.join(
            [
              slot.parking_place,
              "| Free: ",
              slot.available_slots,
              " / ",
              slot.total_slots
            ],
            " "
          ),
        loc_lat_long: loc_lat_long
      })

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"parking" => parking_params}) do
    user = Parkin.Authentication.load_current_user(conn)
    parking_params = Map.put(parking_params, "user_id", user.id)

    # TIME LOGIC START

    now_dt = DateTime.utc_now()
    start_dt = now_dt

    # Add checks for parsing integers

    start_dt =
      Map.put(
        start_dt,
        :year,
        Integer.parse(parking_params["start"]["year"]) |> elem(0)
      )

    start_dt =
      Map.put(
        start_dt,
        :month,
        Integer.parse(parking_params["start"]["month"]) |> elem(0)
      )

    start_dt =
      Map.put(
        start_dt,
        :day,
        Integer.parse(parking_params["start"]["day"]) |> elem(0)
      )

    start_dt =
      Map.put(
        start_dt,
        :hour,
        Integer.parse(parking_params["start"]["hour"]) |> elem(0)
      )

    start_dt =
      Map.put(
        start_dt,
        :minute,
        Integer.parse(parking_params["start"]["minute"]) |> elem(0)
      )

    start_dt = Map.put(start_dt, :second, 0)

    start_dt = Map.put(start_dt, :microsecond, {0, 0})

    end_dt = now_dt

    end_dt =
      Map.put(
        end_dt,
        :year,
        Integer.parse(parking_params["end"]["year"]) |> elem(0)
      )

    end_dt =
      Map.put(
        end_dt,
        :month,
        Integer.parse(parking_params["end"]["month"]) |> elem(0)
      )

    end_dt =
      Map.put(
        end_dt,
        :day,
        Integer.parse(parking_params["end"]["day"]) |> elem(0)
      )

    end_dt =
      Map.put(
        end_dt,
        :hour,
        Integer.parse(parking_params["end"]["hour"]) |> elem(0)
      )

    end_dt =
      Map.put(
        end_dt,
        :minute,
        Integer.parse(parking_params["end"]["minute"]) |> elem(0)
      )

    end_dt = Map.put(end_dt, :second, 0)

    end_dt = Map.put(end_dt, :microsecond, {0, 0})

    case DateTime.compare(start_dt, now_dt) do
      :lt ->
        conn
        |> put_flash(:error, "Selected start date is before now")
        |> redirect(to: Routes.parkingsearch_path(conn, :search))

      _ ->
        nil
    end

    case DateTime.compare(start_dt, end_dt) do
      :gt ->
        conn
        |> put_flash(:error, "Selected end date is before selected start date")
        |> redirect(to: Routes.parkingsearch_path(conn, :search))

      _ ->
        nil
    end

    parking_duration_minutes = div(DateTime.diff(end_dt, start_dt), 60)

    # TIME LOGIC END

    slot =
      Repo.get_by(Parkin.ParkingSearch.ParkingSlot, loc_lat_long: parking_params["loc_lat_long"])

    case slot == nil do
      true ->
        conn
        |> put_flash(:error, "The selected slot has not been found")
        |> redirect(to: Routes.parkingsearch_path(conn, :search))

      _ ->
        slot
    end

    # Oh yes, dirty. Maybe better add a reservations table instead?...eh...
    case slot.lock != nil do
      true ->
        conn
        |> put_flash(:error, "The selected slot in currently unavailable. Please try again")
        |> redirect(to: Routes.parkingsearch_path(conn, :search))

      _ ->
        nil
    end

    case slot.reserved_slots + slot.available_slots - slot.total_slots >= slot.slot_buffer do
      true ->
        conn
        |> put_flash(:error, "No free spaces left")
        |> redirect(to: Routes.parkingsearch_path(conn, :search))

      _ ->
        nil
    end

    service = Repo.get_by(Service, zone: slot.zone, type: parking_params["type"])

    case service == nil do
      true ->
        conn
        |> put_flash(:error, "This service is unavailable")
        |> redirect(to: Routes.parkingsearch_path(conn, :search))

      _ ->
        service
    end

    parking_params = Map.put(parking_params, "service_id", service.id)

    parking_params =
      Map.put(parking_params, "amount", div(parking_duration_minutes, service.duration))

    parking_params = Map.put(parking_params, "price", parking_params["amount"] * service.price)

    # lock! (no..not a transaction...whatever...)
    slot =
      Parkin.ParkingSearch.ParkingSlot.changeset(slot)
      |> Ecto.Changeset.put_change(:lock, 0)

    slot =
      case Repo.update(slot) do
        {:ok, slot} ->
          slot

        _ ->
          conn
          |> put_flash(:error, "Something has gone horribly wrong")
          |> redirect(to: Routes.parkingsearch_path(conn, :search))
      end

    order = Repo.get_by(Parkin.Billing.Order, user_id: user.id, status: "active")

    order =
      case order do
        nil ->
          order_struct =
            Ecto.build_assoc(user, :orders, %{
              user_id: user.id,
              service_id: service.id,
              payment_id: nil,
              loc_lat_long: parking_params["loc_lat_long"],
              comment:
                Enum.join(
                  [
                    slot.parking_place,
                    "|",
                    service.name,
                    "| Free: ",
                    slot.available_slots,
                    " / ",
                    slot.total_slots
                  ],
                  " "
                ),
              status: "active"
            })

          changeset = Parkin.Billing.Order.changeset(order_struct, %{})
          Repo.insert!(changeset)

        _ ->
          order
          # ELSE -> get latest parking dates for comparison
      end

    parking_params = Map.put(parking_params, "order_id", order.id)

    # keep locked!
    slot =
      Parkin.ParkingSearch.ParkingSlot.changeset(slot)
      |> Ecto.Changeset.put_change(:reserved_slots, slot.reserved_slots + 1)
      |> Ecto.Changeset.put_change(:lock, order.id)

    slot =
      case Repo.update(slot) do
        {:ok, slot} ->
          slot

        _ ->
          conn
          |> put_flash(:error, "Something has gone horribly wrong")
          |> redirect(to: Routes.parkingsearch_path(conn, :search))
      end

    # if current order active - compare dates

    case Sales.create_parking(parking_params) do
      {:ok, parking} ->
        # unlock and update
        slot =
          Parkin.ParkingSearch.ParkingSlot.changeset(slot)
          |> Ecto.Changeset.put_change(:available_slots, slot.available_slots - 1)
          |> Ecto.Changeset.put_change(:lock, nil)

        case Repo.update(slot) do
          {:ok, slot} ->
            slot

          _ ->
            conn
            |> put_flash(:error, "Something has gone horribly wrong")
            |> redirect(to: Routes.parkingsearch_path(conn, :search))
        end

        conn
        |> put_flash(:info, "Parking created successfully.")
        |> redirect(to: Routes.parking_path(conn, :show, parking))

      {:error, %Ecto.Changeset{} = changeset} ->
        # unlock and rollback
        slot =
          Parkin.ParkingSearch.ParkingSlot.changeset(slot)
          |> Ecto.Changeset.put_change(:reserved, slot.reserved - 1)
          |> Ecto.Changeset.put_change(:lock, nil)

        case Repo.update(slot) do
          {:ok, slot} ->
            slot

          _ ->
            conn
            |> put_flash(:error, "Something has gone horribly wrong")
            |> redirect(to: Routes.parkingsearch_path(conn, :search))
        end

        conn
        |> put_flash(:info, "An error occured.")
        |> render("new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    parking = Sales.get_parking!(id)
    render(conn, "show.html", parking: parking)
  end

  def edit(conn, %{"id" => id}) do
    parking = Sales.get_parking!(id)
    changeset = Sales.change_parking(parking)
    render(conn, "edit.html", parking: parking, changeset: changeset)
  end

  def update(conn, %{"id" => id, "parking" => parking_params}) do
    parking = Sales.get_parking!(id)

    case Sales.update_parking(parking, parking_params) do
      {:ok, parking} ->
        conn
        |> put_flash(:info, "Parking updated successfully.")
        |> redirect(to: Routes.parking_path(conn, :show, parking))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", parking: parking, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    parking = Sales.get_parking!(id)
    {:ok, _parking} = Sales.delete_parking(parking)

    conn
    |> put_flash(:info, "Parking deleted successfully.")
    |> redirect(to: Routes.parking_path(conn, :index))
  end
end
