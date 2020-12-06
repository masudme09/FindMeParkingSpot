defmodule Parkin.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :password, :string, virtual: true
    field :hashed_password, :string
    field :name, :string
    field :license_number, :string
    field :tokens, :integer
    field :type, :string

    has_many :payments, Parkin.Billing.Payment
    has_many :parkings, Parkin.Sales.Parking
    has_many :orders, Parkin.Billing.Order

    timestamps()
  end

  @spec changeset(
          {map, map} | %{:__struct__ => atom | %{__changeset__: map}, optional(atom) => any},
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :name, :license_number, :tokens, :type])
    |> cast_assoc(:payments)
    |> cast_assoc(:parkings)
    |> cast_assoc(:orders)
    |> validate_required([:username, :name, :license_number ]) #:type
    |> unique_constraint(:username)
    |> validate_format(:username, ~r/@/, message: "Username must be an email address!")
    |> validate_length(:password, min: 6)
    |> hash_password
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, hashed_password: Pbkdf2.hash_pwd_salt(password))
  end

  defp hash_password(changeset), do: changeset
end
