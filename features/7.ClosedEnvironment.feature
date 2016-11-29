Feature: Closed environment

  @skip
  Scenario: Admin can manage closed environment
    Given I logged in as "Admin"
    And I click the "Users management" tab
    When I click the "Customers" tab
    And I type "First" into "Search name" field
    And I click the "Search" button
    And I should see table with "Customers"
    And I look for the first "Customer" with "First" name within "Customers" table
    And I click the "View" it
    Then I am on the "Customer details" page
    And I click the "Manage isolated environment" button
    And I am on the "Manage environment" page
    And I fill in form as follows:
      | description    | New env for TEST   |
      | check checkbox | Enable environment |
    And I click the "Create" button
    And I click the "Add role" button
    And I fill in form as follows:
      | role title      | Role for TEST |
      | role logo image | image2.jpg    |
      | regular price   | 1             |
      | urgent price    | 2             |
    And I select worker with email "legend521@ukr.net" from "Add new worker" dropdown
    And I click the "Update" button
    And I should see the text "Environment has been updated"
    Then I go back
    And I am on the "Customer details" page
    And I click the "Delete customer" button
    And I accept pop up message
    And I sleep
    Then I click the "Menu" button
    And I click the "Log out" button

  @closed
  Scenario: Customer creates urgent gig for closed environment
    Given I am on the "Home" page
    And I click the "Sign up" button
    When I am on the "Login" page
    And I fill in form as follows:
      | email    | daniel.vygovskiy@gmail.com |
      | password | 123456                     |
    And I click the "Login" button
    Then I am on the "Dashboard" page
    And I should see the text "Role for TEST"
    When I click the "My gigs" tab
    And I am on the "My gigs" page
    And I should see table with "Gigs"
    And I count gigs with role "Role for TEST"
    Then I click the "New gig" tab
    And I am on the "Dashboard" page
    And I click "1 dag" button
    When I am on the "Create one day gig" page
    And I should see the calendar
    And I choose month december
    Then I set dates:
      | 11 december |
    Then I set up duration from "+2:00" to "+7:00" round local
    And I click the "Set up dates" button
    And I click the "Set venue details" button
    And I fill in form as follows:
      | number of workers | 1      |
      | description       | random |
    And I click the "Proceed" button
    Then I am on the "Confirmation" page
    Then I click the "Finish" button
    Then I am on the "My gigs" page
    And I should see table with "Gigs"
    And I should see 1 more gigs with role "Role for TEST"
    And API deletes latest gig

