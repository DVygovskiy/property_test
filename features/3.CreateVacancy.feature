Feature: Create vacancy


  @create_vac
  Scenario: Vacancy creation
    Given I logged in as "Admin"
    And I click the "Vacancy" tab
    And I am on the "View vacancies" page
    When I should see table with "Vacancies"
    And I click the "Add new vacancy" button
    Then I am on the "Create vacancy" page
    And I fill in form as follows:
      | title             | Test_Vac          |
      | select venue      | VENUE         |
      | select status     | Visible           |
      | select role       | Bardienst         |
      | check checkbox    | role skills first |
      | select skills     | master11            |
      | select clothing   | nude11              |
      | select location   | Earth             |
      | description       | Need a hero!      |
      | venue description | Pub               |
    And I click the "Create" button
    Then I am redirected to "Vacancy details" page
    And I should see such info:
      | Test_Vac     |
      | VENUE     |
      | Visible      |
      | Bardienst    |
      | master       |
      | nude         |
      | Earth        |
      | Need a hero! |
      | Pub          |
