Feature: Change gig status

  Scenario: Admin edit
    And API creates promocode "DANTEST"
    And API create following one day GIG with promo:
      | role              | Bardienst                  |
      | type              | one day                    |
      | date              | +1 day from today          |
      | start time        | + 2 hours from round local |
      | end time          | + 8 hours from round local |
      | description       | Test                       |
      | venue description | My                         |
      | location          | New local                 |
      | number of workers | 1                          |
      | promocode         | DANTEST                   |
    When I logged in as "Admin"
    And I click the "Gigs" tab
    Then I should see table with "Gigs"
    And I look for the first "Gig" with "Pending" status within "Gigs" table
    And I click the "Edit" it
    Then I am on the "Edit gig" page
    And I select "Status" to "Expired"
    And I click the "Update" button
    And I should see the text "Gig is bijgewerkt"
    Then I go back
    And I should see status "Expired" for the first "Gig" within "Gigs" table


@admin
  Scenario: Admin complete
  Given API create following one day GIG with promo:
    | role              | Bardienst                  |
    | type              | one day                    |
    | date              | +1 day from today          |
    | start time        | + 2 hours from round local |
    | end time          | + 8 hours from round local |
    | description       | Test status                       |
    | venue description | My                         |
    | location          | New local                 |
    | number of workers | 1                          |
    | promocode         | DANTEST                    |
  When Worker accept gig with description "Test status"
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

  @delete_gigs
  Scenario: Cleaning
    Given API deletes latest gig

