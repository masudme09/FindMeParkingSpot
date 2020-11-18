Feature: User login
  As an registered user
  Such that I have access to internal features on the ParkIn website
  I want to log in with a username

  Scenario: User login via ParkIn web page (with confirmation)
    Given I would like to log in a user "marko@x.com" with password "qwerty"
    And I open ParkIn login page
    And I enter the login information
    When I summit the request
    Then I should receive a login confirmation message

  Scenario: Booking via STRS' web page (with rejection)
    Given the ParkIn website is operational
    And I would like to log in a user "marko@x.com" with password "qwerty"
    And I open ParkIn login page
    And I enter the login information
    When I summit the request
    Then I should receive a login rejection messag
