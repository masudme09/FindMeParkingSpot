Feature: User logout
  As a registered user
  Such that I have no more access to internal features on the ParkIn website
  I want to log out

  Scenario: User logout via ParkIn web page (with confirmation)
    Given the following users exist
          |      name      |      username     |  password  |  hashed_password | license_number |
          |  Amigo Grande  |  amigo@grande.mx  |   qwerty   |  $pbkdf2-sha512$160000$RXDATuB9gUGqmhgt5NiHUg$W81M1SedlBMVY5wOwlBhNrr2eJ0O2EfRwvbi0L03O7qfVBxTWy6zlfmFIPr93bqZNaD5EQXIHjYSF19L9a/hwg  |     BFG888     |
    And I am logged into the ParkIn website as a registered user "amigo@grande.mx" with password "qwerty"
    When I open ParkIn logout page
    Then I should receive a logout confirmation message
