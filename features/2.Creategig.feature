Feature: Create gig


  @urgent_gig
  Scenario: Urgent gig creation
    Given I logged in as "Valid user"
    And I am on the "Dashboard" page
    When I click the "My gigs" tab
    And I am on the "My gigs" page
    And I should see table with "Gigs"
    And I count gigs with role "Bardienst"
    Then I click the "New gig" tab
    And I am on the "Dashboard" page
    And I click the "One day bardienst" button
    When I am on the "Create one day gig" page
    And I fill in form as follows:
      | set up the date          | to today                            |
      | set up duration          | from "+2:00" to "+7:00" round local |
      | number of workers        | 1                                   |
      | check   checkbox         | clever workers                      |
      | description              | random                              |
      | check   checkbox         | first role skills                   |
      | select required clothing | black shoes                         |
      | select required skills   | superman                            |
    And I click the "Proceed" button
    Then I am on the "Confirmation" page
    Then I click the "Finish" button
    And I am redirected to "Ideal" page
    Then I click the "Ideal" button
    And I select "bank" to "RABO"
    And I click the "Submit" button
    And I click the "Accepted" button
    And I click the "Continue" button
    Then I am on the "My gigs" page
    And I should see table with "Gigs"
    And I should see 1 more gigs with role "Bardienst"

  @one_day_gig_m
  Scenario: Urgent gig creation
    Given I logged in as "Valid user"
    And I am on the "Dashboard" page
    When I click the "My gigs" tab
    And I am on the "My gigs" page
    And I should see table with "Gigs"
    And I count gigs with role "Bediening"
    Then I click the "New gig" tab
    And I am on the "Dashboard" page
    And I click the "One day bediening" button
    When I am on the "Create one day gig" page
    And I fill in form as follows:
      | set up the date          | + 1 day from today                            |
      | set up duration          | from "+2:00" to "+7:00" round local |
      | number of workers        | 2                                   |
      | check   checkbox         | clever workers                      |
      | description              | random                              |
      | select required clothing | black shoes                         |
      | select required skills   | superman                            |
    And I click the "Proceed" button
    Then I am on the "Confirmation" page
    Then I click the "Finish" button
    And I am redirected to "Ideal" page
    Then I click the "Ideal" button
    And I select "bank" to "RABO"
    And I click the "Submit" button
    And I click the "Accepted" button
    And I click the "Continue" button
    Then I am on the "My gigs" page
    And I should see table with "Gigs"
    And I should see 2 more gigs with role "Bediening"

  @urgent_gig_max
  Scenario: Urgent gig creation
    Given I logged in as "Valid user"
    And I am on the "Dashboard" page
    And I click the "One day bardienst" button
    When I am on the "Create one day gig" page
    And I fill in form as follows:
      | set up the date   | to today                            |
      | set up duration   | from "+2:00" to "+7:00" round local |
      | number of workers | 21                                  |
      | description       | random                              |
    And I click the "Proceed" button
    Then I should see the text "Het maximale aantal medewerkers is 20"


  @multi_gig
  Scenario: Multi gig creation
    Given I logged in as "Valid user"
    And I am on the "Dashboard" page
    And I click the "Multi day bardienst" button
    When I am on the "Create multi day gig" page
    And I fill in form as follows:
      | check   checkbox | discreet days |
    And I should see the calendar
    And I choose month december
    Then I set dates:
      | 11 december |
      | 15 december |
      | 12 januari  |
    And I click the "Set dates" button
    And I set up table of timings as:
      | from "11:00" to "16:00" |
      | from "11:00" to "16:00" |
      | from "11:00" to "16:00" |
    And I click the "Set time" button
    And I check "many workers" checkbox
    And I type "New test" into "description" field
    And I click the "Proceed" button
    Then I click the "Finish" button
    And I am redirected to "Ideal" page
    Then I click the "Ideal" button
    And I select "bank" to "RABO"
    And I click the "Submit" button
    And I click the "Accepted" button
    And I click the "Continue" button
    And I should see the text "Meerdaagse gig, begint op 11 december"