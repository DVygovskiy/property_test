Feature: Registration

  Background:
    Given I resize window to "1240x960"

  @sk
  Scenario: Registration with image
    Given I open the "Home" page
    And I click the "Register" button
    And I type "random email" into "Email" field
    And I type "random password" into "Password" field
    And I click the "Create account" button
    When I see pop up with "Welkom bij clevergig" text
    And I check "Agree terms" checkbox
    And I click the "Complete profile" button
    Then I am redirected to "Complete profile" page
    And I fill in form as follows:
      | venue name   | test 22    |
      | description  | For Chrome |
      | first name   | First      |
      | last name    | Last       |
      | phone number | 09999999   |
      | kvk          | 12345      |
      | btw          | 12345      |
      | street       | Street     |
      | house number | 1          |
      | postcode     | 1111qq     |
    And I click the "Submit" button
    And I sleep
    Then I am redirected to "Dashboard" page
    And I click the "Menu" tab
    And I click the "Profile" tab
    And I am on the "General info" page
    And I should see such info:
      | test 22    |
      | For Chrome |
      | First      |
      | Last       |
      | 09999999   |
      | 12345      |
      | 12345      |
      | 12345      |
      | Street     |
      | 1          |
      | 1111qq     |
    And I upload "Family2.png" image as "Company logo"

  Scenario: CSV
    Given API test csv
