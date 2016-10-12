Feature: Change gig status



  Scenario: Personal gig creation2
    Given API create following GIG:
      | role              | Bardienst                 |
      | type              | Urgent                    |
      | date              | today        |
      | start time        | + 3 hours from round local |
      | end time          | + 10 hours from round local |
      | description       | Test                      |
      | venue description | My                        |
      | location          | Amsterdam                 |
    When I logged in as "Admin"
    And I click the "Gigs" tab
    Then I should see table with "Gigs"
    And I look for the first "Gig" with "Expired" status within "Gigs" table
    And I click the "Edit" it

@admin
    Scenario: Admin edit
      Given I logged in as "Admin"
      And I click the "Gigs" tab
      Then I should see table with "Gigs"
      And I look for the first "Gig" with "Pending" status within "Gigs" table
      And I click the "Edit" it
      Then I am on the "Edit gig" page
      And I select "Status" to "Expired"
      And I click the "Update" button
      And I should see the text "Gig is bijgewerkt "
      Then I go back
      And I should see status "Expired" for the first "Gig" within "Gigs" table

@admin
  Scenario: Admin complete
  Given API create following GIG:
    | role              | Bardienst                 |
    | type              | Urgent                    |
    | date              | today        |
    | start time        | + 3 hours from round local |
    | end time          | + 10 hours from round local |
    | description       | Test                      |
    | venue description | My                        |
    | location          | Amsterdam                 |
  When Worker accept gig with description "Test"
  Then I logged in as "Admin"
  And I click the "Gigs" tab
  Then I should see table with "Gigs"
  And I look for the first "Gig" with "Accepted" status within "Gigs" table
  And I click the "Edit" it
  Then I am on the "Edit gig" page
  And I select "Status" to "Completed"
  And I click the "Update" button
  And I should see the text "Gig is bijgewerkt "
  Then I go back
  And I should see status "Completed" for the first "Gig" within "Gigs" table


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

@gig
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
