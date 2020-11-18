defmodule WhiteBreadContext do
  use WhiteBread.Context
  use Hound.Helpers

  import Ecto.Query, only: [from: 2]

  alias Takso.{Repo, Sales.Taxi}
  alias Takso.Accounts.User

  feature_starting_state(fn ->
    Application.ensure_all_started(:hound)
    %{}
  end)

  scenario_starting_state(fn _state ->
    Hound.start_session()
    Ecto.Adapters.SQL.Sandbox.checkout(Takso.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(Takso.Repo, {:shared, self()})
    %{}
  end)

  scenario_finalize(fn _status, _state ->
    Ecto.Adapters.SQL.Sandbox.checkin(Takso.Repo)
    Hound.end_session()
  end)

  given_(
    ~r/^I would like to register a user "(?<username>[^"]+)" with password "(?<password>[^"]+)" and license plate "(?<license_plate>[^"]+)"$/,
    fn state, %{username: username, password: password, license_plate: license_plate} ->
      {:ok,
       state
       |> Map.put(:username, username)
       |> Map.put(:password, password)
       |> Map.put(:license_plate, license_plate)}
    end
  )

  given_(
    ~r/^I would like to log in a user "(?<username>[^"]+)" with password "(?<password>[^"]+)"$/,
    fn state, %{username: usernams, password: password} ->
      {:ok,
       state
       |> Map.put(:username, username)
       |> Map.put(:password, password)}
    end
  )

  given_(
    ~r/^I am logged into the ParkIn website as a registered user "(?<username>[^"]+)" with password "(?<password>[^"]+)"$/,
    fn state, %{username: username, password: password} ->
      navigate_to("/")

      form = find_element(:id, "session-form")
      usrfld = find_within_element(form, :id, "session_username")
      pswdfld = find_within_element(form, :id, "session_password")
      submit = find_within_element(form, :id, "submit-button")

      usrfld |> fill_field(username)
      pswdfld |> fill_field(password)
      submit |> click()

      :timer.sleep(3000)
      assert visible_in_page?(~r/Welcome #{state[:username]}/)
      {:ok, state}
    end
  )

  
  and_(~r/^I open ParkIn registration page$/, fn state ->
    navigate_to("/users/register")
    {:ok, state}
  end)

  and_(~r/^I enter the registration information$/, fn state ->
    fill_field({:id, "username"}, state[:username])
    fill_field({:id, "password"}, state[:password])
    fill_field({:id, "license_plate"}, state[:license_plate])
    {:ok, state}
  end)

  
  and_(~r/^I open ParkIn login page$/, fn state ->
    navigate_to("/users/login")
    {:ok, state}
  end)

  and_(~r/^I enter the login information$/, fn state ->
    fill_field({:id, "username"}, state[:username])
    fill_field({:id, "password"}, state[:password])
    {:ok, state}
  end)

  
  when_(~r/^I summit the request$/, fn state ->
    click({:id, "submit_button"})
    {:ok, state}
  end)

  
  when_(~r/^I open ParkIn logout page$/, fn state ->
    navigate_to("/users/logout")
    {:ok, state}
  end)


  then_(~r/^I should receive a registration confirmation message$/, fn state ->
    :timer.sleep(10000)
    assert visible_in_page?(~r/User #{state[:username] registered/)
    {:ok, state}
  end)

  then_(~r/^I should receive a registration rejection message$/, fn state ->
    :timer.sleep(10000)
    assert visible_in_page?(~r/User #{state[:username] already exists/)
    {:ok, state}
  end)
  
  then_(~r/^I should receive a login confirmation message$/, fn state ->
    :timer.sleep(10000)
    assert visible_in_page?(~r/Welcome #{state[:username]/)
    {:ok, state}
  end)

  then_(~r/^I should receive a login rejection message$/, fn state ->
    :timer.sleep(10000)
    assert visible_in_page?(~r/Incorrect credentials/)
    {:ok, state}
  end)

  then_(~r/^I should receive a logout confirmation message$/, fn state ->
    :timer.sleep(10000)
    assert visible_in_page?(~r/Successful logout/)
    {:ok, state}
  end)
  
end
