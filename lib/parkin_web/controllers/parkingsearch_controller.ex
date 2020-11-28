defmodule ParkinWeb.ParkingsearchController do
  use ParkinWeb, :controller

  def search(conn, _params) do
    render(conn, "search.html")
  end

  def summary(conn, _params) do
    render(conn, "summary.html")
  end
end
