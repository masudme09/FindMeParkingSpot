Feature: User login
  As an registered user
  Such that I have access to internal features on the ParkIn website
  I want to log in with a username

  Scenario: User login via ParkIn web page (with confirmation)
    Given the following users exist
          |      name      |      username     |  password  |                                   hashed_password                                   | license_number |
          |  Amigo Grande  |  amigo@grande.mx  |   qwerty   |  $pbkdf2-sha512$160000$RXDATuB9gUGqmhgt5NiHUg$W81M1SedlBMVY5wOwlBhNrr2eJ0O2EfRwvbi0L03O7qfVBxTWy6zlfmFIPr93bqZNaD5EQXIHjYSF19L9a/hwg  |     BFG888     |
    And I would like to log in a user "amigo@grande.mx" with password "qwerty"
    And I open ParkIn login page
    And I enter the login information
    When I summit the request
    Then I should receive a login confirmation message

  Scenario: User login via ParkIn web page (with rejection)
    Given the following users exist
          |      name      |      username     |  password  |                                   hashed_password                                   | license_number |
          |  Amigo Grande  |  amigo@grande.mx  |   qwerty   |  $pbkdf2-sha512$160000$RXDATuB9gUGqmhgt5NiHUg$W81M1SedlBMVY5wOwlBhNrr2eJ0O2EfRwvbi0L03O7qfVBxTWy6zlfmFIPr93bqZNaD5EQXIHjYSF19L9a/hwg  |     BFG888     |
    And I would like to log in a user "marko@x.com" with password "qwerty"
    And I open ParkIn login page
    And I enter the login information
    When I summit the request
    Then I should receive a login rejection message
