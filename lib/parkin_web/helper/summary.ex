defmodule Parkin.Helper.Summary do
  alias Parkin.Geolocation
  alias Parkin.Repo

  alias Parkin.ParkingSearch.ParkingSlot
  alias Parkin.ParkingSearch.Pricing
  import Ecto.Query, only: [from: 2]

#   defstruct  [:parking_place, :lat_long, :distance, :zone, :hourly, :realtime ]
#   @type t :: %Summary{parking_place: String.t, lat_long: String.t,distance: float(),
#                       zone: String.t(),hourly: non_neg_integer(),realtime: non_neg_integer()}


  def list_of_all_lat_long() do
    query = from ps in ParkingSlot,
            select: ps.loc_lat_long
    Repo.all(query)
  end

  def get_zone_data_from(lat_long) do
    query = from ps in ParkingSlot,
            where: ps.loc_lat_long == ^lat_long,
            select: [ps.zone,ps.parking_place]
    Repo.one!(query)
  end

  def get_zone_payment_data_from(lat_long) do
    query = from ps in ParkingSlot,
            join: p in Pricing, on: ps.zone == p.zone,
            where: ps.loc_lat_long == ^lat_long,
            select: [ps.parking_place,ps.zone,p.hourly,p.realtime]
    Repo.one!(query)
  end

  def get_lat_long_of_dest_address(parking_place_name) do
    query = from ps in ParkingSlot,
            where: ps.parking_place == ^parking_place_name,
            select: ps.loc_lat_long
    Repo.one!(query)
  end

  def summary_data(dest_lat_long,list_of_destination_lat_long) do
    list_of_destination_lat_long = Enum.filter(list_of_destination_lat_long, fn current_lat_long -> current_lat_long != dest_lat_long end)
    for single_lat_long_probable_destination <- list_of_destination_lat_long do
      get_zone_payment_data_from(single_lat_long_probable_destination) ++ [single_lat_long_probable_destination,Float.to_string(Geolocation.probable_distance(dest_lat_long,single_lat_long_probable_destination))]
    end
  end

  def distance_between(dest_lat_long,list_of_destination_lat_long) do
    list_of_destination_lat_long = Enum.filter(list_of_destination_lat_long, fn current_lat_long -> current_lat_long != dest_lat_long end)
    for single_lat_long_probable_destination <- list_of_destination_lat_long do
      get_zone_data_from(single_lat_long_probable_destination) ++ [single_lat_long_probable_destination,Float.to_string(Geolocation.probable_distance(dest_lat_long,single_lat_long_probable_destination))]
    end
  end

end
