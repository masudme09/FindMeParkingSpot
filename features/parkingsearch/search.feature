Feature: Interactive Search of Parking Space
  As a user 
  Such that I open parking space search page
  I want to search available parking space into the system.

    Scenario: Search available parking space 
        Given I am on the parking search page
        And I have search for "Juhan Liivi 2" as destination location  from "Kalevi 4" as current location on the search page
        When I click on search button
        Then I should see available parking space on that location.