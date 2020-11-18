defmodule Mix.Tasks.Parkin.Seed do
  use Mix.Task

  import Ecto

  alias Parkin.{Repo}

  def run(_) do
    Mix.Task.run("app.start", [])
    seed(Mix.env())
  end

  def seed(:dev) do
  end

  # def seed(:test) do
  # end
end
