Feature: Interactive Search of Parking Space
  As a user 
  Such that I open parking space search page
  I want to search available parking space into the system.

    Scenario: Search available parking space(Confirmation) 
        Given I am on the parking search page
        And I have search for "Veski" as destination location on the search page
        When I click on search button
        Then I should see available parking space summary on that location when parking slot is available.

    # Scenario: Search available parking space(Rejection) 
    #     Given I am on the parking search page
    #     And I have search for "Veski" as destination location on the search page
    #     When I click on search button
    #     Then I should not see available parking space summary on that location when parking slot is not available.