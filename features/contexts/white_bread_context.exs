defmodule WhiteBreadContext do
  use WhiteBread.Context
  use Hound.Helpers

  # import Ecto.Query, only: [from: 2]

  alias Parkin.{Repo, Accounts.User}
  alias Parkin.Geolocation

  feature_starting_state(fn ->
    Application.ensure_all_started(:hound)
    %{}
  end)

  scenario_starting_state(fn _state ->
    Hound.start_session()
    Ecto.Adapters.SQL.Sandbox.checkout(Parkin.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(Parkin.Repo, {:shared, self()})
    %{}
  end)

  scenario_finalize(fn _status, _state ->
    Ecto.Adapters.SQL.Sandbox.checkin(Parkin.Repo)
    Hound.end_session()
  end)

  given_(~r/^the following users exist$/, fn state, %{table_data: table} ->
    table
    |> Enum.map(fn user -> User.changeset(%User{}, user) end)
    |> Enum.each(fn changeset -> Repo.insert!(changeset) end)

    {:ok, state}
  end)

  and_(
    ~r/^I would like to log in a user "(?<username>[^"]+)" with password "(?<password>[^"]+)"$/,
    fn state, %{username: username, password: password} ->
      {:ok,
       state
       |> Map.put(:username, username)
       |> Map.put(:password, password)}
    end
  )

  and_(
    ~r/^I would like to register a user "(?<username>[^"]+)" with password "(?<password>[^"]+)", name "(?<name>[^"]+)" and license number "(?<license_number>[^"]+)"$/,
    fn state,
       %{name: name, username: username, password: password, license_number: license_number} ->
      {:ok,
       state
       |> Map.put(:name, name)
       |> Map.put(:username, username)
       |> Map.put(:password, password)
       |> Map.put(:license_number, license_number)}
    end
  )

  and_(
    ~r/^I am logged into the ParkIn website as a registered user "(?<username>[^"]+)" with password "(?<password>[^"]+)"$/,
    fn state, %{username: username, password: password} ->
      navigate_to("/sessions/new")

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
    navigate_to("/users/new")
    {:ok, state}
  end)

  and_(~r/^I enter the registration information$/, fn state ->
    fill_field({:id, "user_name"}, state[:name])
    fill_field({:id, "user_username"}, state[:username])
    fill_field({:id, "user_password"}, state[:password])
    fill_field({:id, "user_license_number"}, state[:license_number])
    {:ok, state}
  end)

  and_(~r/^I open ParkIn login page$/, fn state ->
    navigate_to("/sessions/new")
    {:ok, state}
  end)

  and_(~r/^I enter the login information$/, fn state ->
    fill_field({:id, "session_username"}, state[:username])
    fill_field({:id, "session_password"}, state[:password])
    {:ok, state}
  end)

  when_(~r/^I summit the request$/, fn state ->
    click({:id, "submit-button"})
    {:ok, state}
  end)

  when_(~r/^I open ParkIn logout page$/, fn state ->
    find_element(:link_text, "Log out")
    |> click()

    :timer.sleep(3000)
    {:ok, state}
  end)

  then_(~r/^I should receive a registration confirmation message$/, fn state ->
    :timer.sleep(5000)
    assert visible_in_page?(~r/User created successfully./)
    {:ok, state}
  end)

  then_(~r/^I should receive a registration rejection message$/, fn state ->
    :timer.sleep(5000)
    assert visible_in_page?(~r/Oops, something went wrong! Please check the errors below./)
    {:ok, state}
  end)

  then_(~r/^I should receive a login confirmation message$/, fn state ->
    :timer.sleep(5000)
    assert visible_in_page?(~r/Welcome #{state[:username]}/)
    {:ok, state}
  end)

  then_(~r/^I should receive a login rejection message$/, fn state ->
    :timer.sleep(5000)
    assert visible_in_page?(~r/Bad Credentials/)
    {:ok, state}
  end)

  then_(~r/^I should receive a logout confirmation message$/, fn state ->
    :timer.sleep(5000)
    assert visible_in_page?(~r/Successful logout/)
    {:ok, state}
  end)

  given_(~r/^I am on the parking search page$/, fn state ->
    :timer.sleep(5000)
    navigate_to("/parking/search")
    {:ok, state}
  end)

  and_(
    ~r/^I have search for "(?<destination_address>[^"]+)" as destination location on the search page$/,
    fn state, %{destination_address: destination_address} ->
      :timer.sleep(5000)

      form = find_element(:id, "search-form")
      searchfld = find_within_element(form, :id, "searchtext")
      searchfld |> fill_field(destination_address)

      :timer.sleep(5000)

      {:ok, state}
    end
  )

  when_(~r/^I click on search button$/, fn state ->
    click({:class, "suggestLink"})
    click({:id, "submit-button"})
    {:ok, state}
  end)

  then_(
    ~r/^I should see available parking space summary on that location when parking slot is available.$/,
    fn state ->
      :timer.sleep(5000)
      assert visible_in_page?(~r/Available Parking spaces/)
      {:ok, state}
    end
  )

  then_ ~r/^I should not see available parking space summary on that location when parking slot is not available.$/, fn state ->
    :timer.sleep(5000)
    assert visible_in_page?(~r/No available Parking spaces/)
    {:ok, state}
  end

  # given_(
  #   ~r/^I am on the parking summary page for destination address "(?<destination_address>[^"]+)"$/,
  #   fn state, %{destination_address: destination_address} ->
  #     navigate_to("/parking/search")
  #     form = find_element(:id, "search-form")
  #     searchfld = find_within_element(form, :id, "searchtext")
  #     searchfld |> fill_field(destination_address)
  #     click({:id, "submit-button"})
  #     :timer.sleep(20000)
  #     assert visible_in_page?(~r/Available Parking spaces/)

  #     {:ok, state}
  #   end
  # )

  # when_ ~r/^I have selected parking location and I click on select button$/, fn state ->
  # # then_ ~r/^I should not see available parking space summary on that location when parking slot is not available.$/, fn state ->
  # #   :timer.sleep(5000)
  # #   assert visible_in_page?(~r/No Available Parking spaces/)
  # #   {:ok, state}
  # # end

  given_(
    ~r/^I am on the parking summary page for destination address "(?<destination_address>[^"]+)"$/,
    fn state, %{destination_address: destination_address} ->
      navigate_to("/parking/search")
      form = find_element(:id, "search-form")
      searchfld = find_within_element(form, :id, "searchtext")
      searchfld |> fill_field(destination_address)
      click({:id, "submit-button"})
      :timer.sleep(20000)
      assert visible_in_page?(~r/Available Parking spaces/)

      {:ok, state}
    end
  )

  when_(~r/^I have selected parking location and I click on select button$/, fn state ->
    :timer.sleep(5000)

    find_element(:link_text, "Select Kastani")
    |> click()

    :timer.sleep(5000)
    {:ok, state}
  end)

  then_(~r/^I should see parking space detail at that location.$/, fn state ->
    :timer.sleep(5000)
    assert visible_in_page?(~r/Parking summary/)
    :timer.sleep(5000)
    {:ok, state}
  end)
end
