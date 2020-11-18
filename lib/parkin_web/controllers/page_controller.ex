defmodule ParkinWeb.PageController do
  use ParkinWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
