Feature: Registration

  Background:
    Given I resize window to "1240x960"
  @reg
  Scenario: Registration with image
    Given I open the "Home" page
    And I click the "Register" button
    And I type "22new@new1.com" into "Email" field
    And I type "123456" into "Password" field
    And I click the "Create account" button
    When I see pop up with "Welkom bij clevergig" text
    And I chceck "Agree terms" checkbox
    And I click the "Complete profile" button
    Then I am redirected to "Complete profile" page
    And I click the "Menu" tab
    And I click the "General info" tab
    Then I am on the "General info" page
    And I upload "Family2.png" image as "Company logo"
    And I upload "image2.jpg" image as "Company galery"
    And I sleep
