defmodule ParkinWeb.SessionController do
  use ParkinWeb, :controller

  alias Parkin.Repo
  alias Parkin.Accounts.User

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"username" => username, "password" => password}}) do
    user = Repo.get_by(User, username: username)

    case Parkin.Authentication.check_credentials(user, password) do
      {:ok, _} ->
        conn
        |> Parkin.Authentication.login(user)
        |> put_flash(:info, "Welcome #{username}")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Bad Credentials")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> Parkin.Authentication.logout()
    |> put_flash(:info, "Successful logout")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
