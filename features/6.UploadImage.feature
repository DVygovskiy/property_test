Feature: Upload image for Role
  

  @admin_upload_image
  Scenario: Admin can upload image for role
    Given I logged in as "Admin"
    And I click the "Roles" tab
    When I am on the "Roles" page
    And I should see table with "Roles"
    And I look for the "Role" with "Barista" title within "Roles" table
    And I click the "Edit" it
    Then I am on the "Edit role" page
    And I upload "barista.jpeg" image as "Role logo"
    And I click the "Update" button
    And I should see the text "Role has been updated"
