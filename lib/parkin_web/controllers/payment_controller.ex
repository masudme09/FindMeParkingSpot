defmodule ParkinWeb.PaymentController do
  use ParkinWeb, :controller
  import Ecto.Query

  alias Parkin.Billing
  alias Parkin.Billing.Payment
  alias Parkin.Billing.Order

  def index(conn, _params) do
    payments =
      Billing.list_payments()
      |> Parkin.Repo.preload(orders: :payment)

    render(conn, "index.html", payments: payments)
  end

  def new(conn, params) do
    order_id =
      case params["order_id"] != nil do
        true -> params["order_id"]
        _ -> 0
      end

    user = Parkin.Authentication.load_current_user(conn)

    order =
      Parkin.Repo.get_by(Parkin.Billing.Order,
        payment_status: "pending",
        user_id: user.id,
        id: order_id
      )
      |> Parkin.Repo.preload(
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
          nil

          conn
          |> put_flash(:error, "Order not found. Nothing to pay...")
          |> redirect(to: Routes.parking_path(conn, :index))

        _ ->
          case order.parkings do
            nil ->
              conn
              |> put_flash(:error, "No parkings found for order")
              |> redirect(to: Routes.parking_path(conn, :index))

            _ ->
              order
          end
      end

    amount_to_pay = order.parkings |> Enum.map(& &1.amount) |> Enum.sum()

    changeset =
      Billing.change_payment(%Payment{amount_to_pay: amount_to_pay, virt_order_id: order.id})

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"payment" => payment_params}) do
    order_id =
      case payment_params["virt_order_id"] != nil do
        true -> payment_params["virt_order_id"]
        _ -> 0
      end

    user_amount =
      case payment_params["amount"] != nil do
        true -> Integer.parse(payment_params["amount"]) |> elem(0)
        _ -> 0
      end

    user = Parkin.Authentication.load_current_user(conn)

    order =
      Parkin.Repo.get_by(Parkin.Billing.Order,
        user_id: user.id,
        payment_status: "pending",
        id: order_id
      )
      |> Parkin.Repo.preload(
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
          nil

          conn
          |> put_flash(:error, "Order not found. Nothing to pay...")
          |> redirect(to: Routes.parking_path(conn, :index))

        _ ->
          case order.parkings do
            nil ->
              conn
              |> put_flash(:error, "No parkings found for order")
              |> redirect(to: Routes.parking_path(conn, :index))

            _ ->
              order
          end
      end

    amount_to_pay = order.parkings |> Enum.map(& &1.amount) |> Enum.sum()

    case amount_to_pay > user_amount do
      true ->
        conn
        |> put_flash(:error, "Not enough moneyz. Pay more!")
        |> redirect(to: Routes.payment_path(conn, :new, %{order_id: order.id}))

      _ ->
        payment_params = Map.put(payment_params, "status", "confirmed")

        IO.inspect(payment_params)

        case Billing.create_payment(payment_params) do
          {:ok, payment} ->
            order =
              Order.changeset(order, %{})
              |> Ecto.Changeset.put_change(:payment_status, "paid")
              |> Ecto.Changeset.put_change(:payment_id, payment.id)

            case Parkin.Repo.update(order) do
              {:ok, order} ->
                order

              _ ->
                conn
                |> put_flash(:error, "Something has gone horribly wrong")
                |> redirect(to: Routes.parkingsearch_path(conn, :search))
            end

            conn
            |> put_flash(:info, "Payment created successfully.")
            |> redirect(to: Routes.payment_path(conn, :index))

          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "new.html", changeset: changeset)
        end
    end
  end

  def show(conn, %{"id" => id}) do
    payment = Billing.get_payment!(id)
    render(conn, "show.html", payment: payment)
  end

  def edit(conn, %{"id" => id}) do
    payment = Billing.get_payment!(id)
    changeset = Billing.change_payment(payment)
    render(conn, "edit.html", payment: payment, changeset: changeset)
  end

  def update(conn, %{"id" => id, "payment" => payment_params}) do
    payment = Billing.get_payment!(id)

    case Billing.update_payment(payment, payment_params) do
      {:ok, payment} ->
        conn
        |> put_flash(:info, "Payment updated successfully.")
        |> redirect(to: Routes.payment_path(conn, :show, payment))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", payment: payment, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    payment = Billing.get_payment!(id)
    {:ok, _payment} = Billing.delete_payment(payment)

    conn
    |> put_flash(:info, "Payment deleted successfully.")
    |> redirect(to: Routes.payment_path(conn, :index))
  end
end
