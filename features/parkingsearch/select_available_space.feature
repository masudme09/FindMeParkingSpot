Feature: Interactive Search of Parking Space
  As a user
  Such that I am in parking space summary page
  I want to select available parking space into the system.

    Scenario: Select available parking space
        Given I am on the parking summary page for destination address "Veski, Tartu, Estonia"
        When I have selected parking location and I click on select button
        Then I should see parking space detail at that location.
