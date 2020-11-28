defmodule Parkin.Geolocation do

  alias Parkin.Repo

  alias Parkin.ParkingSearch.ParkingSlot
  import Ecto.Query, only: [from: 2]

  def find_location(address) do
    uri = "http://dev.virtualearth.net/REST/v1/Locations?q=1#{URI.encode(address)}%&key=#{get_key()}"
    response = HTTPoison.get! uri
    matches = Regex.named_captures(~r/coordinates\D+(?<lat>-?\d+.\d+)\D+(?<long>-?\d+.\d+)/, response.body)
    [{v1, _}, {v2, _}] = [matches["lat"] |> Float.parse, matches["long"] |> Float.parse]
    [v1, v2]
  end

  def distance(origin, destination) do
    [o1, o2]  = find_location(origin)
    [d1, d2] = find_location(destination)

    uri = "https://dev.virtualearth.net/REST/v1/Routes/DistanceMatrix?origins=#{o1},#{o2}&destinations=#{d1},#{d2}&travelMode=driving&key=#{get_key()}"
    response = HTTPoison.get! uri
    matches = Regex.named_captures(~r/travelD\D+(?<dist>\d+.\d+)\D+(?<dur>\d+.\d+)/,response.body)
    [{v1, _}, {v2, _}] = [matches["dist"] |> Float.parse, matches["dur"] |> Float.parse]
    [v1, v2]
 end

 def probable_distance(origin_lat_long, destination_lat_long) do
  [o1, o2] = String.split(origin_lat_long, ",")
  [d1, d2] = String.split(destination_lat_long, ",")
  [{o1,_}, {o2,_}, {d1,_}, {d2,_}] = [o1 |> Float.parse, o2 |> Float.parse, d1 |> Float.parse, d2 |> Float.parse]
  uri = "https://dev.virtualearth.net/REST/v1/Routes/DistanceMatrix?origins=#{o1},#{o2}&destinations=#{d1},#{d2}&travelMode=driving&key=#{get_key()}"
  response = HTTPoison.get! uri
  matches = Regex.named_captures(~r/travelD\D+(?<distance>\d+.\d+)/,response.body)
  [{calculated_distance_between_two_place,_}] = [matches["distance"] |> Float.parse]
  calculated_distance_between_two_place

end

def list_of_all_lat_long() do
  query = from ps in ParkingSlot,
          select: ps.loc_lat_long
  Repo.all(query)
end

def distance_between(dest_lat_long,list_of_destination_lat_long) do
  list_of_destination_lat_long = Enum.filter(list_of_destination_lat_long, fn current_lat_long -> current_lat_long != dest_lat_long end)
  for single_lat_long_probable_destination <- list_of_destination_lat_long do
    [single_lat_long_probable_destination,probable_distance(dest_lat_long,single_lat_long_probable_destination)]
  end
end

  defp get_key(), do: "Avg6Y6Q2bxNg9JmKQjKelyVssmALndKw9kZCU0ws9siu_JQb-JIsyilkLJeDH9T0"
end
