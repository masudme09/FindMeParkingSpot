defmodule ParkinWeb.PaymentController do
  use ParkinWeb, :controller

  alias Parkin.Billing
  alias Parkin.Billing.Payment

  def index(conn, _params) do
    payments = Billing.list_payments()
    render(conn, "index.html", payments: payments)
  end

  def new(conn, _params) do
    changeset = Billing.change_payment(%Payment{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"payment" => payment_params}) do
    case Billing.create_payment(payment_params) do
      {:ok, payment} ->
        conn
        |> put_flash(:info, "Payment created successfully.")
        |> redirect(to: Routes.payment_path(conn, :show, payment))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
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
