defmodule Parkin.ParkingSearch do
  @moduledoc """
  The ParkingSearch context.
  """

  import Ecto.Query, warn: false
  alias Parkin.Repo

  alias Parkin.ParkingSearch.ParkingSlot

  @doc """
  Returns the list of parking_slots.

  ## Examples

      iex> list_parking_slots()
      [%ParkingSlot{}, ...]

  """
  def list_parking_slots do
    Repo.all(ParkingSlot)
  end

  @doc """
  Gets a single parking_slot.

  Raises `Ecto.NoResultsError` if the Parking slot does not exist.

  ## Examples

      iex> get_parking_slot!(123)
      %ParkingSlot{}

      iex> get_parking_slot!(456)
      ** (Ecto.NoResultsError)

  """
  def get_parking_slot!(id), do: Repo.get!(ParkingSlot, id)

  @doc """
  Creates a parking_slot.

  ## Examples

      iex> create_parking_slot(%{field: value})
      {:ok, %ParkingSlot{}}

      iex> create_parking_slot(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_parking_slot(attrs \\ %{}) do
    %ParkingSlot{}
    |> ParkingSlot.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a parking_slot.

  ## Examples

      iex> update_parking_slot(parking_slot, %{field: new_value})
      {:ok, %ParkingSlot{}}

      iex> update_parking_slot(parking_slot, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_parking_slot(%ParkingSlot{} = parking_slot, attrs) do
    parking_slot
    |> ParkingSlot.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a parking_slot.

  ## Examples

      iex> delete_parking_slot(parking_slot)
      {:ok, %ParkingSlot{}}

      iex> delete_parking_slot(parking_slot)
      {:error, %Ecto.Changeset{}}

  """
  def delete_parking_slot(%ParkingSlot{} = parking_slot) do
    Repo.delete(parking_slot)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking parking_slot changes.

  ## Examples

      iex> change_parking_slot(parking_slot)
      %Ecto.Changeset{data: %ParkingSlot{}}

  """
  def change_parking_slot(%ParkingSlot{} = parking_slot, attrs \\ %{}) do
    ParkingSlot.changeset(parking_slot, attrs)
  end
end
