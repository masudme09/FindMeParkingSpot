Feature: Fee calculation based hourly or real time payment selection
     As a user
     Such that I am in parking booking page 
     I should be able to get payment calculation based on hourly or realtime that I have selected

     Scenario: Hourly payment calculation
         Given I am logged in the system
         And I am in parking search page and enter "Veski, Tartu, Estonia" as destination
         And I have selected "Select Kastani" as my parking space and new parking page appears
         And I click on type checkbox and select "hourly"  
         And I have entered my leaving hour
         When I have clicked on submit button
         Then I should able to see calculated price as hourly rate for that booking

    Scenario: Real time payment calculation
         Given I am logged in the system
         And I am in parking search page and enter "Veski, Tartu, Estonia" as destination
         And I have selected "Select Kastani" as my parking space and new parking page appears  
         And I select "realtime"  
         And I have entered my leaving hour
         When I have clicked on submit button
         Then I should able to see calculated price as Real time rate for that booking
