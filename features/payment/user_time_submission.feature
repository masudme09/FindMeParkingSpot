Feature: System allows a car driver to submit start and end of parking time
     As a user
     Such that I am in parking booking page 
     I should be able to submit start and end of parking time

     Scenario: Allows a car driver to submit valid start and end of parking time
         Given I am logged in the system
         And I am in parking search page and enter "Veski, Tartu, Estonia" as destination
         And I have selected "Select Kastani" as my parking space and new parking page appears
         And I click on type dropdown and select "hourly" 
         And I enter starting date as "2020" year "12" month "7" day "21" hour and "50" minutes
         And I enter ending date as "2020" year "12" month "7" day "22" hour and "50" minutes
         When I clicked submit button 
         Then It should shows payment created successfully as message.

    Scenario: Car driver submitting before date as end date than start date as parking time
         Given I am logged in the system
         And I am in parking search page and enter "Veski, Tartu, Estonia" as destination
         And I have selected "Select Kastani" as my parking space and new parking page appears
         And I click on type dropdown and select "hourly" 
         And I enter starting date as "2020" year "12" month "7" day "21" hour and "50" minutes
         And I enter ending date as "2020" year "12" month "6" day "22" hour and "50" minutes
         When I clicked submit button 
         Then It should show before date as error message.
    
    Scenario: Car driver submitting selected start date is before now as parking time
         Given I am logged in the system
         And I am in parking search page and enter "Veski, Tartu, Estonia" as destination
         And I have selected "Select Kastani" as my parking space and new parking page appears
         And I click on type dropdown and select "hourly" 
         And I enter starting date as "2020" year "12" month "7" day "21" hour and "50" minutes
         And I enter ending date as "2020" year "12" month "6" day "22" hour and "50" minutes
         When I clicked submit button 
         Then It should show Selected start date is before now.
    
         

   