Feature: Select hourly or real time payment type selection
     As a user
     Such that I am in parking booking page 
     I should be able to select hourly or real time payment as my payment type

     Scenario: Hourly payment type selection
         Given I am in login page and enter user "masudme09@gmail.com" with password "lunerescape628"
         And I am in parking search page and enter "Veski, Tartu, Estonia" as destination
         And I have selected "Veski" as my parking space and new parking page appears
         When I click on type checkbox and select Hourly  
         Then Hourly payment type will be selected 

    Scenario: Real time payment type selection
         Given I am in login page and enter user "masudme09@gmail.com" with password "lunerescape628"
         And I am in parking search page and enter "Veski, Tartu, Estonia" as destination
         And I have selected "Veski" as my parking space and new parking page appears
         When I click on type checkbox and select Real time  
         Then Hourly payment type will be selected 