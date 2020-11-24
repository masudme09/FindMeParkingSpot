defmodule Parkin.PaymentsTest do
  use Parkin.DataCase

  alias Parkin.Payments

  describe "purchases" do
    alias Parkin.Payments.Purchase

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def purchase_fixture(attrs \\ %{}) do
      {:ok, purchase} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Payments.create_purchase()

      purchase
    end

    test "list_purchases/0 returns all purchases" do
      purchase = purchase_fixture()
      assert Payments.list_purchases() == [purchase]
    end

    test "get_purchase!/1 returns the purchase with given id" do
      purchase = purchase_fixture()
      assert Payments.get_purchase!(purchase.id) == purchase
    end

    test "create_purchase/1 with valid data creates a purchase" do
      assert {:ok, %Purchase{} = purchase} = Payments.create_purchase(@valid_attrs)
    end

    test "create_purchase/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Payments.create_purchase(@invalid_attrs)
    end

    test "update_purchase/2 with valid data updates the purchase" do
      purchase = purchase_fixture()
      assert {:ok, %Purchase{} = purchase} = Payments.update_purchase(purchase, @update_attrs)
    end

    test "update_purchase/2 with invalid data returns error changeset" do
      purchase = purchase_fixture()
      assert {:error, %Ecto.Changeset{}} = Payments.update_purchase(purchase, @invalid_attrs)
      assert purchase == Payments.get_purchase!(purchase.id)
    end

    test "delete_purchase/1 deletes the purchase" do
      purchase = purchase_fixture()
      assert {:ok, %Purchase{}} = Payments.delete_purchase(purchase)
      assert_raise Ecto.NoResultsError, fn -> Payments.get_purchase!(purchase.id) end
    end

    test "change_purchase/1 returns a purchase changeset" do
      purchase = purchase_fixture()
      assert %Ecto.Changeset{} = Payments.change_purchase(purchase)
    end
  end

  describe "invoices" do
    alias Parkin.Payments.Invoice

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def invoice_fixture(attrs \\ %{}) do
      {:ok, invoice} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Payments.create_invoice()

      invoice
    end

    test "list_invoices/0 returns all invoices" do
      invoice = invoice_fixture()
      assert Payments.list_invoices() == [invoice]
    end

    test "get_invoice!/1 returns the invoice with given id" do
      invoice = invoice_fixture()
      assert Payments.get_invoice!(invoice.id) == invoice
    end

    test "create_invoice/1 with valid data creates a invoice" do
      assert {:ok, %Invoice{} = invoice} = Payments.create_invoice(@valid_attrs)
    end

    test "create_invoice/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Payments.create_invoice(@invalid_attrs)
    end

    test "update_invoice/2 with valid data updates the invoice" do
      invoice = invoice_fixture()
      assert {:ok, %Invoice{} = invoice} = Payments.update_invoice(invoice, @update_attrs)
    end

    test "update_invoice/2 with invalid data returns error changeset" do
      invoice = invoice_fixture()
      assert {:error, %Ecto.Changeset{}} = Payments.update_invoice(invoice, @invalid_attrs)
      assert invoice == Payments.get_invoice!(invoice.id)
    end

    test "delete_invoice/1 deletes the invoice" do
      invoice = invoice_fixture()
      assert {:ok, %Invoice{}} = Payments.delete_invoice(invoice)
      assert_raise Ecto.NoResultsError, fn -> Payments.get_invoice!(invoice.id) end
    end

    test "change_invoice/1 returns a invoice changeset" do
      invoice = invoice_fixture()
      assert %Ecto.Changeset{} = Payments.change_invoice(invoice)
    end
  end

  describe "currencies" do
    alias Parkin.Payments.Currency

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def currency_fixture(attrs \\ %{}) do
      {:ok, currency} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Payments.create_currency()

      currency
    end

    test "list_currencies/0 returns all currencies" do
      currency = currency_fixture()
      assert Payments.list_currencies() == [currency]
    end

    test "get_currency!/1 returns the currency with given id" do
      currency = currency_fixture()
      assert Payments.get_currency!(currency.id) == currency
    end

    test "create_currency/1 with valid data creates a currency" do
      assert {:ok, %Currency{} = currency} = Payments.create_currency(@valid_attrs)
    end

    test "create_currency/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Payments.create_currency(@invalid_attrs)
    end

    test "update_currency/2 with valid data updates the currency" do
      currency = currency_fixture()
      assert {:ok, %Currency{} = currency} = Payments.update_currency(currency, @update_attrs)
    end

    test "update_currency/2 with invalid data returns error changeset" do
      currency = currency_fixture()
      assert {:error, %Ecto.Changeset{}} = Payments.update_currency(currency, @invalid_attrs)
      assert currency == Payments.get_currency!(currency.id)
    end

    test "delete_currency/1 deletes the currency" do
      currency = currency_fixture()
      assert {:ok, %Currency{}} = Payments.delete_currency(currency)
      assert_raise Ecto.NoResultsError, fn -> Payments.get_currency!(currency.id) end
    end

    test "change_currency/1 returns a currency changeset" do
      currency = currency_fixture()
      assert %Ecto.Changeset{} = Payments.change_currency(currency)
    end
  end
end
