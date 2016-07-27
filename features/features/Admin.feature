Feature: Create gig


  @admin
  Scenario: Personal gig creation
    Given API create following GIG:
      | role              | Bardienst                 |
      | type              | Urgent                    |
      | date              | today        |
      | start time        | + 3 hours from round local |
      | end time          | + 10 hours from round local |
      | description       | Test                      |
      | venue description | My                        |
      | location          | Amsterdam                 |


   @urgent_gig
   Scenario: Urgent gig creation
     Given I loged in as "Valid user"
     And I am on the "Dashboard" page
     And I click the "Urgent bardienst" button
     When I am on the "Gig details" page
     And I set up date to today
     And I type "Test" into "Description" field
     And I set up duration from "+2:00" to "+7:00" round local
     And I click the "Proceed" button
     Then I am on the "Confirmation" page
     And I select "Payment system" to "AfterPay"
     And I agree with Terms
     And I click the "Finish" button
     Then I am on the "My gigs" page
     And I should see table with "Gigs"


     @DB
     Scenario: DB
       Given I am connected to mysql


