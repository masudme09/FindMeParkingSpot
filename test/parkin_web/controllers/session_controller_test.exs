defmodule ParkinWeb.SessionControllerTest do
  use ParkinWeb.ConnCase

  alias Parkin.Guardian
  alias Parkin.Accounts

  @create_attrs %{
    username: "amigo@grande.mx",
    password: "qwerty"
  }
  @update_attrs %{}
  @invalid_attrs %{
    username: "amigo@grande.mx",
    password: "1234"
  }

  @user_attrs %{
    username: "amigo@grande.mx",
    name: "Amigo Grande",
    license_number: "BFG888",
    password: "qwerty",
    hashed_password:
      "$pbkdf2-sha512$160000$RXDATuB9gUGqmhgt5NiHUg$W81M1SedlBMVY5wOwlBhNrr2eJ0O2EfRwvbi0L03O7qfVBxTWy6zlfmFIPr93bqZNaD5EQXIHjYSF19L9a/hwg"
  }

  def guardian_login(user) do
    build_conn()
    |> bypass_through(Parkin.Router, [:browser, :browser_authenticated_session])
    |> get("/")
    |> Map.update!(:state, fn _ -> :set end)
    |> Guardian.Plug.sign_in(user)
    |> send_resp(200, "Flush the session")
    |> recycle
  end

  def guardian_logout(user) do
    build_conn()
    |> bypass_through(Parkin.Router, [:browser, :browser_authenticated_session])
    |> get("/")
    |> Guardian.Plug.sign_out(user)
    |> send_resp(200, "Flush the session")
    |> recycle
  end

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@user_attrs)
    user
  end

  describe "new session" do
    setup [:create_user]

    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.session_path(conn, :new))
      assert html_response(conn, 200) =~ "User Log In"
    end
  end

  describe "create session" do
    setup [:create_user]

    test "success flash msg when data is valid", %{conn: conn, user: user} do
      conn = post(conn, Routes.session_path(conn, :create), session: @create_attrs)
      assert redirected_to(conn) == Routes.page_path(conn, :index)
      assert get_flash(conn, :info) =~ ~r/Welcome #{user.username}/
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.session_path(conn, :create), session: @invalid_attrs)
      assert html_response(conn, 200) =~ "User Log In"
      assert get_flash(conn, :error) =~ "Bad Credentials"
    end
  end

  describe "delete session" do
    setup [:create_user]

    test "deletes chosen session", %{conn: conn, user: user} do
      conn = delete(conn, Routes.session_path(conn, :delete, user.id))
      assert redirected_to(conn) == Routes.page_path(conn, :index)
      assert get_flash(conn, :info) =~ "Successful logout"
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    conn = guardian_login(user)

    %{user: user, conn: conn}
  end
end
