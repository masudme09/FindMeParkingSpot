last_push_masdefmodule Parkin.BillingTest do
  use Parkin.DataCase

  alias Parkin.Billing

  describe "payments" do
    alias Parkin.Billing.Payment

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def payment_fixture(attrs \\ %{}) do
      {:ok, payment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Billing.create_payment()

      payment
    end

    test "list_payments/0 returns all payments" do
      payment = payment_fixture()
      assert Billing.list_payments() == [payment]
    end

    test "get_payment!/1 returns the payment with given id" do
      payment = payment_fixture()
      assert Billing.get_payment!(payment.id) == payment
    end

    test "create_payment/1 with valid data creates a payment" do
      assert {:ok, %Payment{} = payment} = Billing.create_payment(@valid_attrs)
    end

    test "create_payment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Billing.create_payment(@invalid_attrs)
    end

    test "update_payment/2 with valid data updates the payment" do
      payment = payment_fixture()
      assert {:ok, %Payment{} = payment} = Billing.update_payment(payment, @update_attrs)
    end

    test "update_payment/2 with invalid data returns error changeset" do
      payment = payment_fixture()
      assert {:error, %Ecto.Changeset{}} = Billing.update_payment(payment, @invalid_attrs)
      assert payment == Billing.get_payment!(payment.id)
    end

    test "delete_payment/1 deletes the payment" do
      payment = payment_fixture()
      assert {:ok, %Payment{}} = Billing.delete_payment(payment)
      assert_raise Ecto.NoResultsError, fn -> Billing.get_payment!(payment.id) end
    end

    test "change_payment/1 returns a payment changeset" do
      payment = payment_fixture()
      assert %Ecto.Changeset{} = Billing.change_payment(payment)
    end
  end

  describe "invoices" do
    alias Parkin.Billing.Invoice

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def invoice_fixture(attrs \\ %{}) do
      {:ok, invoice} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Billing.create_invoice()

      invoice
    end

    test "list_invoices/0 returns all invoices" do
      invoice = invoice_fixture()
      assert Billing.list_invoices() == [invoice]
    end

    test "get_invoice!/1 returns the invoice with given id" do
      invoice = invoice_fixture()
      assert Billing.get_invoice!(invoice.id) == invoice
    end

    test "create_invoice/1 with valid data creates a invoice" do
      assert {:ok, %Invoice{} = invoice} = Billing.create_invoice(@valid_attrs)
    end

    test "create_invoice/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Billing.create_invoice(@invalid_attrs)
    end

    test "update_invoice/2 with valid data updates the invoice" do
      invoice = invoice_fixture()
      assert {:ok, %Invoice{} = invoice} = Billing.update_invoice(invoice, @update_attrs)
    end

    test "update_invoice/2 with invalid data returns error changeset" do
      invoice = invoice_fixture()
      assert {:error, %Ecto.Changeset{}} = Billing.update_invoice(invoice, @invalid_attrs)
      assert invoice == Billing.get_invoice!(invoice.id)
    end

    test "delete_invoice/1 deletes the invoice" do
      invoice = invoice_fixture()
      assert {:ok, %Invoice{}} = Billing.delete_invoice(invoice)
      assert_raise Ecto.NoResultsError, fn -> Billing.get_invoice!(invoice.id) end
    end

    test "change_invoice/1 returns a invoice changeset" do
      invoice = invoice_fixture()
      assert %Ecto.Changeset{} = Billing.change_invoice(invoice)
    end
  end

  describe "currencies" do
    alias Parkin.Billing.Currency

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def currency_fixture(attrs \\ %{}) do
      {:ok, currency} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Billing.create_currency()

      currency
    end

    test "list_currencies/0 returns all currencies" do
      currency = currency_fixture()
      assert Billing.list_currencies() == [currency]
    end

    test "get_currency!/1 returns the currency with given id" do
      currency = currency_fixture()
      assert Billing.get_currency!(currency.id) == currency
    end

    test "create_currency/1 with valid data creates a currency" do
      assert {:ok, %Currency{} = currency} = Billing.create_currency(@valid_attrs)
    end

    test "create_currency/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Billing.create_currency(@invalid_attrs)
    end

    test "update_currency/2 with valid data updates the currency" do
      currency = currency_fixture()
      assert {:ok, %Currency{} = currency} = Billing.update_currency(currency, @update_attrs)
    end

    test "update_currency/2 with invalid data returns error changeset" do
      currency = currency_fixture()
      assert {:error, %Ecto.Changeset{}} = Billing.update_currency(currency, @invalid_attrs)
      assert currency == Billing.get_currency!(currency.id)
    end

    test "delete_currency/1 deletes the currency" do
      currency = currency_fixture()
      assert {:ok, %Currency{}} = Billing.delete_currency(currency)
      assert_raise Ecto.NoResultsError, fn -> Billing.get_currency!(currency.id) end
    end

    test "change_currency/1 returns a currency changeset" do
      currency = currency_fixture()
      assert %Ecto.Changeset{} = Billing.change_currency(currency)
    end
  end

  describe "rates" do
    alias Parkin.Billing.Rate

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def rate_fixture(attrs \\ %{}) do
      {:ok, rate} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Billing.create_rate()

      rate
    end

    test "list_rates/0 returns all rates" do
      rate = rate_fixture()
      assert Billing.list_rates() == [rate]
    end

    test "get_rate!/1 returns the rate with given id" do
      rate = rate_fixture()
      assert Billing.get_rate!(rate.id) == rate
    end

    test "create_rate/1 with valid data creates a rate" do
      assert {:ok, %Rate{} = rate} = Billing.create_rate(@valid_attrs)
    end

    test "create_rate/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Billing.create_rate(@invalid_attrs)
    end

    test "update_rate/2 with valid data updates the rate" do
      rate = rate_fixture()
      assert {:ok, %Rate{} = rate} = Billing.update_rate(rate, @update_attrs)
    end

    test "update_rate/2 with invalid data returns error changeset" do
      rate = rate_fixture()
      assert {:error, %Ecto.Changeset{}} = Billing.update_rate(rate, @invalid_attrs)
      assert rate == Billing.get_rate!(rate.id)
    end

    test "delete_rate/1 deletes the rate" do
      rate = rate_fixture()
      assert {:ok, %Rate{}} = Billing.delete_rate(rate)
      assert_raise Ecto.NoResultsError, fn -> Billing.get_rate!(rate.id) end
    end

    test "change_rate/1 returns a rate changeset" do
      rate = rate_fixture()
      assert %Ecto.Changeset{} = Billing.change_rate(rate)
    end
  end

  describe "orders" do
    alias Parkin.Billing.Order

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def order_fixture(attrs \\ %{}) do
      {:ok, order} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Billing.create_order()

      order
    end

    test "list_orders/0 returns all orders" do
      order = order_fixture()
      assert Billing.list_orders() == [order]
    end

    test "get_order!/1 returns the order with given id" do
      order = order_fixture()
      assert Billing.get_order!(order.id) == order
    end

    test "create_order/1 with valid data creates a order" do
      assert {:ok, %Order{} = order} = Billing.create_order(@valid_attrs)
    end

    test "create_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Billing.create_order(@invalid_attrs)
    end

    test "update_order/2 with valid data updates the order" do
      order = order_fixture()
      assert {:ok, %Order{} = order} = Billing.update_order(order, @update_attrs)
    end

    test "update_order/2 with invalid data returns error changeset" do
      order = order_fixture()
      assert {:error, %Ecto.Changeset{}} = Billing.update_order(order, @invalid_attrs)
      assert order == Billing.get_order!(order.id)
    end

    test "delete_order/1 deletes the order" do
      order = order_fixture()
      assert {:ok, %Order{}} = Billing.delete_order(order)
      assert_raise Ecto.NoResultsError, fn -> Billing.get_order!(order.id) end
    end

    test "change_order/1 returns a order changeset" do
      order = order_fixture()
      assert %Ecto.Changeset{} = Billing.change_order(order)
    end
  end
end
