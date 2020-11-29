defmodule Parkin.Geolocation do

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

  defp get_key(), do: "Avg6Y6Q2bxNg9JmKQjKelyVssmALndKw9kZCU0ws9siu_JQb-JIsyilkLJeDH9T0"
end
