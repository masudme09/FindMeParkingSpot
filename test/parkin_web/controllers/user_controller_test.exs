defmodule ParkinWeb.UserControllerTest do
  use ParkinWeb.ConnCase

  alias Parkin.Guardian
  alias Parkin.Accounts

  @create_attrs %{
    username: "amigo@grande.mx",
    name: "Amigo Grande",
    license_number: "BFG888",
    password: "qwerty",
    hashed_password:
      "$pbkdf2-sha512$160000$RXDATuB9gUGqmhgt5NiHUg$W81M1SedlBMVY5wOwlBhNrr2eJ0O2EfRwvbi0L03O7qfVBxTWy6zlfmFIPr93bqZNaD5EQXIHjYSF19L9a/hwg"
  }
  @update_attrs %{
    username: "marko@x.com",
    name: "Marc McLaughlin",
    license_number: "XDOTCOM01",
    password: "qwerty"
  }
  @invalid_attrs %{
    username: nil,
    name: nil,
    license_number: nil,
    password: nil
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
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  describe "index" do
    setup [:create_user]

    test "lists all users", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Users"
    end
  end

  describe "new user" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :new))
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "create user" do
    test "success flash msg when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
      assert get_flash(conn, :info) =~ "User created successfully."
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "edit user" do
    setup [:create_user]

    test "renders form for editing chosen user", %{conn: conn, user: user} do
      conn = get(conn, Routes.user_path(conn, :edit, user))
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "update user" do
    setup [:create_user]

    test "redirects when data is valid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @update_attrs)
      assert redirected_to(conn) == Routes.user_path(conn, :show, user)

      conn = get(conn, Routes.user_path(conn, :show, user))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, Routes.user_path(conn, :delete, user))
      assert redirected_to(conn) == Routes.user_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_path(conn, :show, user))
      end
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    conn = guardian_login(user)

    %{user: user, conn: conn}
  end
end
