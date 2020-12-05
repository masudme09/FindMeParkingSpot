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

  def new(conn, %{"loc_lat_long" => loc_lat_long}) do
    slot = Parkin.Helper.Summary.get_zone_data_from(loc_lat_long)

    case slot == nil do
      true ->
        conn
        |> put_flash(:error, "The selected slot has not been found")
        |> redirect(to: Routes.parkingsearch_path(conn, :search))

      _ ->
        case Enum.at(slot, 2) <= 0 do
          true ->
            conn
            |> put_flash(:error, "No free spaces left")
            |> redirect(to: Routes.parkingsearch_path(conn, :search))

          _ ->
            user = Parkin.Authentication.load_current_user(conn)
            order = Repo.get_by(Parkin.Billing.Order, user_id: user.id, status: "active")

            # case order == nil do
            #   true ->
            #     struct = Ecto.build_assoc(user, :order, %{

            #                               })
            # end

            # Magic People Voodoo People
            slot_data =
              Enum.join(
                [Enum.at(slot, 1), "| Free: ", Enum.at(slot, 2), " / ", Enum.at(slot, 3)],
                " "
              )

            changeset =
              Sales.change_parking(%Parking{
                type: "realtime",
                slot: slot_data,
                loc_lat_long: loc_lat_long
              })

            render(conn, "new.html", changeset: changeset)
        end
    end
  end

  def create(conn, %{"parking" => parking_params}) do
    slot = Parkin.Helper.Summary.get_zone_data_from(parking_params["loc_lat_long"])

    case slot == nil do
      true ->
        conn
        |> put_flash(:error, "The selected slot has not been found")
        |> redirect(to: Routes.parkingsearch_path(conn, :search))

      _ ->
        case Enum.at(slot, 2) <= 0 do
          true ->
            conn
            |> put_flash(:error, "No free spaces left")
            |> redirect(to: Routes.parkingsearch_path(conn, :search))

          _ ->
            service = Repo.get_by(Service, zone: Enum.at(slot, 0), type: parking_params["type"])

            case service == nil do
              true ->
                conn
                |> put_flash(:error, "This service is unavailable")
                |> redirect(to: Routes.parkingsearch_path(conn, :search))

              _ ->
                user = Parkin.Authentication.load_current_user(conn)

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
                                Enum.at(slot, 1),
                                "|",
                                service.name,
                                "| Free: ",
                                Enum.at(slot, 2),
                                " / ",
                                Enum.at(slot, 3)
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

                parking_params = Map.put(parking_params, "user_id", user.id)
                parking_params = Map.put(parking_params, "service_id", service.id)
                parking_params = Map.put(parking_params, "order_id", order.id)

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

                duration_minutes = div(DateTime.diff(end_dt, start_dt), 60)

                # if current order active - compare dates

                parking_params =
                  Map.put(parking_params, "amount", div(duration_minutes, service.duration))

                parking_params =
                  Map.put(parking_params, "price", parking_params["amount"] * service.price)

                case Sales.create_parking(parking_params) do
                  {:ok, parking} ->
                    conn
                    |> put_flash(:info, "Parking created successfully.")
                    |> redirect(to: Routes.parking_path(conn, :show, parking))

                  {:error, %Ecto.Changeset{} = changeset} ->
                    conn
                    |> put_flash(:info, "An error occured.")
                    |> render("new.html", changeset: changeset)
                end
            end
        end
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
