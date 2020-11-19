Feature: User registration
  As an unregistered user
  Such that I have access to internal features on the ParkIn website
  I want to register a username

  Scenario: User registration via ParkIn web page (with confirmation)
    Given I would like to register a user "marko@x.com" with password "qwerty", name "Marc McLaughlin" and license number "XDOTCOM01"
    And I open ParkIn registration page
    And I enter the registration information
    When I summit the request
    Then I should receive a registration confirmation message

  Scenario: Booking via STRS' web page (with rejection)
    Given I would like to register a user "marko@x.com" with password "qwerty", name "Marc McLaughlin" and license number "XDOTCOM01"
    And I open ParkIn registration page
    And I enter the registration information
    When I summit the request
    Then I should receive a registration rejection message
