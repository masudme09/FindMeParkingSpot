defmodule ParkinWeb.ParkingController do
  use ParkinWeb, :controller

  import Ecto.Query

  alias Parkin.Sales
  alias Parkin.Sales.Parking
  alias Parkin.Sales.Service
  alias Parkin.Repo

  def index(conn, _params) do
    parkings =
      Sales.list_parkings()
      |> Repo.preload(
        order: :parkings,
        service: :parkings
      )

    render(conn, "index.html", parkings: parkings)
  end

  @spec new(Plug.Conn.t(), map) :: Plug.Conn.t()
  def new(conn, %{"loc_lat_long" => loc_lat_long}) do
      slot = Parkin.Helper.Summary.get_zone_data_from(loc_lat_long)
      
  def new(conn, params) do
    loc_lat_long = params["loc_lat_long"]

    slot =
      case loc_lat_long do
        nil -> nil
        _ -> Repo.get_by(Parkin.ParkingSearch.ParkingSlot, loc_lat_long: loc_lat_long)
      end

    case slot == nil do
      true ->
        conn
        |> put_flash(:error, "The selected slot has not been found")
        |> redirect(to: Routes.parkingsearch_path(conn, :search))

      _ ->
        user = Parkin.Authentication.load_current_user(conn)

        order =
          Repo.get_by(Parkin.Billing.Order,
            user_id: user.id,
            status: "active"
          )
          |> Repo.preload(
            service: :orders,
            parkings:
              Ecto.Query.from(
                a in Parkin.Sales.Parking,
                order_by: [desc: a.inserted_at]
              )
          )

        slot_field =
          case order != nil do
            true ->
              Enum.join(
                [
                  slot.parking_place,
                  "| Order",
                  order.id,
                  "Extension "
                ],
                " "
              )

            _ ->
              Enum.join(
                [
                  slot.parking_place,
                  "| Free: ",
                  slot.available_slots,
                  " / ",
                  slot.total_slots
                ],
                " "
              )
          end

        startend =
          case order != nil do
            true -> List.first(order.parkings).end
            _ -> DateTime.utc_now()
          end

        order_type =
          case order != nil do
            true -> order.service.type
            _ -> "realtime"
          end

        changeset =
          Sales.change_parking(%Parking{
            type: order_type,
            start: startend,
            end: startend,
            slot: slot_field,
            loc_lat_long: loc_lat_long
          })

        case slot.reserved_slots + slot.available_slots - slot.total_slots >= slot.slot_buffer and
               order == nil do
          true ->
            conn
            |> put_flash(:error, "No free spaces left")
            |> redirect(to: Routes.parkingsearch_path(conn, :search))

          _ ->
            case order != nil and order.loc_lat_long != loc_lat_long do
              true ->
                conn
                |> put_flash(:error, "You have active parking in another slot")
                |> redirect(to: Routes.parkingsearch_path(conn, :search))

              _ ->
                render(conn, "new.html", changeset: changeset)
            end
        end
    end
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
        case DateTime.compare(start_dt, end_dt) do
          :gt ->
            conn
            |> put_flash(:error, "Selected end date is before selected start date")
            |> redirect(to: Routes.parkingsearch_path(conn, :search))

          _ ->
            parking_duration_minutes = div(DateTime.diff(end_dt, start_dt), 60)

            # TIME LOGIC END

            slot =
              Repo.get_by(Parkin.ParkingSearch.ParkingSlot,
                loc_lat_long: parking_params["loc_lat_long"]
              )

            case slot == nil do
              true ->
                conn
                |> put_flash(:error, "The selected slot has not been found")
                |> redirect(to: Routes.parkingsearch_path(conn, :search))

              _ ->
                # Oh yes, dirty. Maybe better add a reservations table instead?...eh...
                case slot.lock != nil do
                  true ->
                    conn
                    |> put_flash(
                      :error,
                      "The selected slot in currently unavailable. Please try again"
                    )
                    |> redirect(to: Routes.parkingsearch_path(conn, :search))

                  _ ->
                    case slot.reserved_slots + slot.available_slots - slot.total_slots >=
                           slot.slot_buffer do
                      true ->
                        conn
                        |> put_flash(:error, "No free spaces left")
                        |> redirect(to: Routes.parkingsearch_path(conn, :search))

                      _ ->
                        service =
                          Repo.get_by(Service, zone: slot.zone, type: parking_params["type"])

                        case service == nil do
                          true ->
                            conn
                            |> put_flash(:error, "This service is unavailable")
                            |> redirect(to: Routes.parkingsearch_path(conn, :search))

                          _ ->
                            parking_params = Map.put(parking_params, "service_id", service.id)

                            parking_params =
                              Map.put(
                                parking_params,
                                "amount",
                                div(parking_duration_minutes, service.duration)
                              )

                            parking_params =
                              Map.put(
                                parking_params,
                                "price",
                                parking_params["amount"] * service.price
                              )

                            # lock! (no..not a transaction...whatever...)
                            slot =
                              Parkin.ParkingSearch.ParkingSlot.changeset(slot)
                              |> Ecto.Changeset.put_change(:lock, 0)

                            # LISP FIX HERE END 5AM

                            case Repo.update(slot) do
                              {:error, %Ecto.Changeset{} = changeset} ->
                                conn
                                |> put_flash(:error, "Something has gone horribly wrong")
                                |> redirect(to: Routes.parkingsearch_path(conn, :search))

                              _ ->
                                order =
                                  Repo.get_by(Parkin.Billing.Order,
                                    user_id: user.id,
                                    status: "active"
                                  )
                                  |> Repo.preload(
                                    service: :orders,
                                    parkings:
                                      Ecto.Query.from(
                                        a in Parkin.Sales.Parking,
                                        order_by: [desc: a.inserted_at]
                                      )
                                  )

                                order =
                                  case order do
                                    nil ->
                                      order_struct =
                                        Ecto.build_assoc(user, :orders, %{
                                          user_id: user.id,
                                          service_id: service.id,
                                          payment_id: nil,
                                          loc_lat_long: parking_params["loc_lat_long"],
                                          comment: slot.data.parking_place,
                                          status: "active",
                                          payment_status: "pending"
                                        })

                                      changeset =
                                        Parkin.Billing.Order.changeset(order_struct, %{})

                                      Repo.insert!(changeset)

                                    _ ->
                                      case DateTime.compare(
                                             start_dt,
                                             List.first(order.parkings).end
                                           ) do
                                        :lt ->
                                          # unlock
                                          slot =
                                            Parkin.Repo.get_by(Parkin.ParkingSearch.ParkingSlot,
                                              id: slot.data.id
                                            )

                                          slot =
                                            Parkin.ParkingSearch.ParkingSlot.changeset(slot)
                                            |> Ecto.Changeset.put_change(:lock, nil)

                                          case Repo.update(slot) do
                                            {:ok, slot} ->
                                              slot

                                            _ ->
                                              conn
                                              |> put_flash(
                                                :error,
                                                "Something has gone horribly wrong"
                                              )
                                              |> redirect(
                                                to: Routes.parkingsearch_path(conn, :search)
                                              )
                                          end

                                          conn
                                          |> put_flash(
                                            :error,
                                            "Selected start date is before current order end date"
                                          )
                                          |> redirect(to: Routes.parking_path(conn, :index))

                                        _ ->
                                          order
                                      end
                                  end

                                parking_params = Map.put(parking_params, "order_id", order.id)

                                # keep locked!
                                slot =
                                  Parkin.ParkingSearch.ParkingSlot.changeset(slot)
                                  |> Ecto.Changeset.put_change(
                                    :reserved_slots,
                                    slot.data.reserved_slots + 1
                                  )
                                  |> Ecto.Changeset.put_change(:lock, order.id)

                                IO.inspect(slot)
                                IO.inspect(slot.data)

                                slot =
                                  case Repo.update(slot) do
                                    {:error, %Ecto.Changeset{} = changeset} ->
                                      conn
                                      |> put_flash(:error, "Something has gone horribly wrong")
                                      |> redirect(to: Routes.parkingsearch_path(conn, :search))

                                    _ ->
                                      slot
                                  end

                                IO.inspect(slot)
                                IO.inspect(slot.data)

                                case Sales.create_parking(parking_params) do
                                  {:ok, parking} ->
                                    # unlock and update

                                    IO.inspect(slot)
                                    IO.inspect(slot.data)

                                    slot =
                                      Parkin.Repo.get_by(Parkin.ParkingSearch.ParkingSlot,
                                        id: slot.data.id
                                      )

                                    IO.inspect(slot)

                                    slot =
                                      Parkin.ParkingSearch.ParkingSlot.changeset(slot)
                                      |> Ecto.Changeset.put_change(
                                        :available_slots,
                                        slot.available_slots - 1
                                      )
                                      |> Ecto.Changeset.put_change(:lock, nil)

                                    case Repo.update(slot) do
                                      {:error, %Ecto.Changeset{} = changeset} ->
                                        conn
                                        |> put_flash(
                                          :error,
                                          "Something has gone horribly wrong"
                                        )
                                        |> redirect(to: Routes.parkingsearch_path(conn, :search))

                                      _ ->
                                        conn
                                        |> put_flash(:info, "Parking created successfully.")
                                        |> redirect(to: Routes.parking_path(conn, :index))
                                    end

                                  {:error, %Ecto.Changeset{} = changeset} ->
                                    # unlock and rollback

                                    slot =
                                      Parkin.Repo.get_by(Parkin.ParkingSearch.ParkingSlot,
                                        id: slot.data.id
                                      )

                                    slot =
                                      Parkin.ParkingSearch.ParkingSlot.changeset(slot)
                                      |> Ecto.Changeset.put_change(
                                        :reserved_slots,
                                        slot.reserved_slots - 1
                                      )
                                      |> Ecto.Changeset.put_change(:lock, nil)

                                    case Repo.update(slot) do
                                      {:error, %Ecto.Changeset{} = changeset} ->
                                        conn
                                        |> put_flash(
                                          :error,
                                          "Something has gone horribly wrong"
                                        )
                                        |> redirect(to: Routes.parkingsearch_path(conn, :search))

                                      _ ->
                                        conn
                                        |> put_flash(:info, "An error occured.")
                                        |> render("new.html", changeset: changeset)
                                    end
                                end
                            end
                        end
                    end
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
