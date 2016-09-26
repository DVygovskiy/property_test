Feature: Decline worker

Background:
    Given API create following GIG:
      | role              | Bardienst                   |
      | type              | Urgent                      |
      | date              | today                       |
      | start time        | + 3 hours from round local  |
      | end time          | + 10 hours from round local |
      | description       | Decline                     |
      | venue description | My                          |
      | location          | Amsterdam                   |
    When Worker accept gig with description "Decline"

  @admin_decline_worker
  Scenario: Admin can Decline worker
    Given I logged in as "Admin"
    And I click the "Gigs" tab
    When I should see table with "Gigs"
    And I look for the first "Gig" with "Accepted" status within "Gigs" table
    And I click the "View" it
    Then I am on the "View gig" page
    And I click the "Decline worker" button
    And I should see the text "De kandidaat is afgewezen"
    Then I go back
    And I should not see status "Accepted" for the first "Gig" within "Gigs" table
    And I should see status "Pending" for the first "Gig" within "Gigs" table


  @customer_decline_worker
  Scenario: Customer can Decline worker
    Given I logged in as "valid user"
    When I check mailbox "clevergig@mail.ru" for "Uw boeking is geaccepteerd" email
    And I open the "Uw boeking is geaccepteerd" email
    Then I quick_click "hier"
    And I am redirected to "Decline worker" page
    And I click the "Confirm" button
    And I should see the text "De kandidaat is afgewezen"

  @customer_decline_worker_notloggedin
  Scenario: Customer can Decline worker
    Given I check mailbox "clevergig@mail.ru" for "Uw boeking is geaccepteerd" email
    And I open the "Uw boeking is geaccepteerd" email
    Then I quick_click "hier"
    And I am redirected to "Login" page
    And I type "clevergig@mail.ru" into "Email" field
    And I type "123456" into "Password" field
    And I click the "Login" button
    And I am redirected to "Decline worker" page
    And I click the "Confirm" button
    And I should see the text "De kandidaat is afgewezen"