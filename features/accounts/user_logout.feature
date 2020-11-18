Feature: User logout
  As a registered user
  Such that I have no more access to internal features on the ParkIn website
  I want to log out

  Scenario: User logout via ParkIn web page (with confirmation)
    Given I am logged into the ParkIn website as a registered user "marko@x.com" with password "qwerty"
    When I open ParkIn logout page
    Then I should receive a logout confirmation message
