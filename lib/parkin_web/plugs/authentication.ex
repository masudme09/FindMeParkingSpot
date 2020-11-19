defmodule Parkin.Authentication do
  alias Parkin.Guardian

  def check_credentials(user, plain_text_password) do
    if user && Pbkdf2.verify_pass(plain_text_password, user.hashed_password) do
      {:ok, user}
    else
      {:error, :unauthorized_user}
    end
  end

  def login(conn, user) do
    Guardian.Plug.sign_in(conn, user)
  end

  def logout(conn) do
    Guardian.Plug.sign_out(conn)
  end

  def load_current_user(conn) do
    Guardian.Plug.current_resource(conn)
  end
end
