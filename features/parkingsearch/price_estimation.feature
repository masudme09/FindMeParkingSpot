Feature: Getting price estimation for selected parking space
    As a user
    Such that I am in parking search page and entered leaving hour
    I want to get price estimation for my parking period for all available parking space

    Scenario: User selects hourly payment system
        Given I am in parking search page 
        And I have entered "3:30PM" as my leaving hour where current time is "1:30PM"
        When I click on submit button 
        Then I should able to see estimated payments for available parking spaces per zone hourly vs realtime

