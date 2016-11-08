Feature: Login

  Background:
    Given I resize window to "1240x960"
  @login
  Scenario: Common login
    Given I open the "Home" page
    And I click the "Sing up" button
    When I am on the "Login" page
    And I type "clevergig@mail.ru" into "Email" field
    And I type "123456" into "Password" field
    And I click the "Login" button
    Then I am on the "Dashboard" page


@admintable
Scenario: Admin table
  When I open the "Home" page
  And I click the "Sing up" button
  Then I am on the "Login" page
  And I type "admin@clevergig.nl" into "Email" field
  And I type "admin" into "Password" field
  And I click the "Login" button
  Then I am on the "Admin" page
  And I click the "Workers" tab
  And I look for "tkach.danilo@mail.ru" within "Workers" table
  And I click the "View" it


@quick
  Scenario: Admin table
    When I open the "Home" page
    And I click the "Sing up" button
    Then I am on the "Login" page
    And I type "admin@clevergig.nl" into "Email" field
    And I type "admin" into "Password" field
    And I click the "Login" button
    Then I am on the "Admin" page
    And I quick_click "Users management"
    And I quick_click "Workers"
    And I quick_click "Export"


@email
Scenario: Email
  Given I check mailbox "daniel.vygovskiy@gmail.com" for "Welcome" email
  When I open the "Completed Event" email
  Then I should see the text "Bedankt voor het voltooien"
  And delete "Completed Event" email

@email2
Scenario: Customer can Decline worker
  Given I logged in as "valid user"
  When I go to the customer's email
  Then I look for the first "email" with "Uw boeking is geaccepteerd" title within "Emails" table
  Then I open the "Uw boeking is geaccepteerd" email
  And I sleep
