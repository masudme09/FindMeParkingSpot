Feature: Getting price estimation for selected parking space
     As a user
     Such that I am in parking summary page and entered leaving hour
     I want to get price estimation for my parking period for selected parking space

     Scenario: Parking slot creation
         Given I am in parking summary page 
         And I have selected "Veski" as my parking space
         And I have entered "2020/12/08 12:00" as my leaving hour and start time is "2020/12/08 00:00"
         When I click on submit button 
         Then I should able to see message "Parking created successfully."

