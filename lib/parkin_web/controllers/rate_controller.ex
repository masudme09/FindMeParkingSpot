defmodule ParkinWeb.RateController do
  use ParkinWeb, :controller

  alias Parkin.Billing
  alias Parkin.Billing.Rate

  def index(conn, _params) do
    rates = Billing.list_rates()
    render(conn, "index.html", rates: rates)
  end

  def new(conn, _params) do
    changeset = Billing.change_rate(%Rate{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"rate" => rate_params}) do
    case Billing.create_rate(rate_params) do
      {:ok, rate} ->
        conn
        |> put_flash(:info, "Rate created successfully.")
        |> redirect(to: Routes.rate_path(conn, :show, rate))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    rate = Billing.get_rate!(id)
    render(conn, "show.html", rate: rate)
  end

  def edit(conn, %{"id" => id}) do
    rate = Billing.get_rate!(id)
    changeset = Billing.change_rate(rate)
    render(conn, "edit.html", rate: rate, changeset: changeset)
  end

  def update(conn, %{"id" => id, "rate" => rate_params}) do
    rate = Billing.get_rate!(id)

    case Billing.update_rate(rate, rate_params) do
      {:ok, rate} ->
        conn
        |> put_flash(:info, "Rate updated successfully.")
        |> redirect(to: Routes.rate_path(conn, :show, rate))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", rate: rate, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    rate = Billing.get_rate!(id)
    {:ok, _rate} = Billing.delete_rate(rate)

    conn
    |> put_flash(:info, "Rate deleted successfully.")
    |> redirect(to: Routes.rate_path(conn, :index))
  end
end
