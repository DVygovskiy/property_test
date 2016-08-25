Feature: Create gig


  @create_gig
  Scenario: Personal gig creation
    Given I loged in as "Valid user"
    And I am on the "Dashboard" page
    And I click the "Personal bardienst" button
    When I am on the "Gig details" page
    And I set up the date to "+2" days from today
    And I type "Test" into "Description" field
    And I set up duration from "+2:00" to "+9:00" round local
    And I click the "Proceed" button
    Then I should see search results with "Workers"
    And I select "Worker" with name "Bad"
    And I select "Payment system" to "AfterPay"
    And I agree with Terms
    And I click the "Finish" button
    Then I am on the "My gigs" page
    And I should see table with "Gigs"


  @urgent_gig
  Scenario: Urgent gig creation
    Given I loged in as "Valid user"
    And I am on the "Dashboard" page
    And I click the "Urgent bardienst" button
    When I am on the "Gig details" page
    And I fill in form as follows:
      | set up the date   | to today                            |
      | description       | random                              |
      | set up duration   | from "+2:00" to "+7:00" round local |
      | check   checkbox  | first role skills                   |
      | required clothing | black shoes                         |
      | required skills   | superman                            |
    And I click the "Proceed" button
    Then I am on the "Confirmation" page
    And I select "Payment system" to "AfterPay"
    And I check "Terms" checkbox
    And I click the "Finish" button
    Then I am on the "My gigs" page
    And I should see table with "Gigs"


  @DB
  Scenario: DB
    Given I am connected to mysql


