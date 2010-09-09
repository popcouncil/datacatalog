@users @admin
Feature: Admin adds an user
  So that I can allow another user utilize all functions of a pop council user and contribute to the world
  As a pop council admin user
  I want to create another pop council admin account in the data catalog

  Scenario Outline: Add a new user from the admin
    Given I am a signed in admin
    When I go to the admin dashboard
    And I follow "User Accounts"
    When I follow "Add New"
    When I select "<role>" from "Role"
    And I fill in "Name" with "John D."
    And I fill in "Email" with "john@test.com"
    And I fill in "Password" with "s3krit"
    And I fill in "Confirm Password" with "s3krit"
    And I select "Uruguay" from "Country"
    And I fill in "City" with "Montevideo"
    And I select "Journalist" from "User Type"
    And I press "Create User"
    Then a new <role> account should be created with "john@test.com"
    And I should see "The user was created and notified"

    Examples:
      | role          |
      | Admin         |
      | Ministry User |
      | Normal User   |

  Scenario: Add an user that doesn't validate
    Given I am a signed in admin
    When I go to the admin dashboard
    And I follow "User Accounts"
    When I follow "Add New"
    And I select "Admin" from "Role"
    And I fill in "Password" with "something"
    And I fill in "Confirm Password" with "something different"
    And I press "Create User"
    Then a new admin account should not be created with "john@test.com"
    And I should see "Password doesn't match confirmation"

  Scenario: Add an user without specifying role
    Given I am a signed in admin
    When I go to the admin dashboard
    And I follow "User Accounts"
    When I follow "Add New"
    And I fill in "Name" with "John D."
    And I fill in "Email" with "john@test.com"
    And I fill in "Password" with "s3krit"
    And I fill in "Confirm Password" with "s3krit"
    And I select "Uruguay" from "Country"
    And I fill in "City" with "Montevideo"
    And I select "Journalist" from "User Type"
    And I press "Create User"
    Then a new Normal User account should be created with "john@test.com"
    And I should see "The user was created and notified"

  Scenario: A newly added admin can log in
    Given I am a site visitor who had an admin account created with "jane@test.com" by an admin
    When I go to sign in
    And I fill in "Email" with "jane@test.com"
    And I fill in "Password" with "test"
    And I press "Sign In"
    Then I should see "Admin"
