Feature: User registration
  As an unregistered user
  Such that I have access to internal features on the ParkIn website
  I want to register a username

  Scenario: User registration via ParkIn web page (with confirmation)
    Given the following users exist
          |      name      |      username     |  password  |  hashed_password | license_number |
          |  Amigo Grande  |  amigo@grande.mx  |   qwerty   |  $pbkdf2-sha512$160000$RXDATuB9gUGqmhgt5NiHUg$W81M1SedlBMVY5wOwlBhNrr2eJ0O2EfRwvbi0L03O7qfVBxTWy6zlfmFIPr93bqZNaD5EQXIHjYSF19L9a/hwg  |     BFG888     |
    And I would like to register a user "marko@x.com" with password "qwerty", name "Marc McLaughlin" and license number "XDOTCOM01"
    And I open ParkIn registration page
    And I enter the registration information
    When I summit the request
    Then I should receive a registration confirmation message

  Scenario: User registration via ParkIn web page (with rejection)
    Given the following users exist
          |      name      |      username     |  password  |  hashed_password | license_number |
          |  Amigo Grande  |  amigo@grande.mx  |   qwerty   |  $pbkdf2-sha512$160000$RXDATuB9gUGqmhgt5NiHUg$W81M1SedlBMVY5wOwlBhNrr2eJ0O2EfRwvbi0L03O7qfVBxTWy6zlfmFIPr93bqZNaD5EQXIHjYSF19L9a/hwg  |     BFG888     |
    And I would like to register a user "amigo@grande.mx" with password "qwerty", name "Amigo Grande" and license number "BFG888"
    And I open ParkIn registration page
    And I enter the registration information
    When I summit the request
    Then I should receive a registration rejection message
