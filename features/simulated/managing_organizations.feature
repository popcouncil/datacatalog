Feature: Managing Organizations
  So that I can control Organizations in the system
  As a pop council admin
  I want to manage organizations

  Background:
    Given I am a signed in admin
    And an organization named "Red Cross" exists
    And an organization named "Some Org" exists

  Scenario Outline: Admin adds an organization
    When I go to the admin dashboard
    And I follow "Organizations"
    When I follow "Add Organization"
    And I fill in "Name" with "Aspiration"
    And I fill in "Acronym" with "ASP"
    And I select "<parent>" from "Parent"  
    And I select "Uruguay" from "Country"  
    And I fill in "Website" with "http://www.aspiration.org"
    And I fill in "Home Page" with "http://www.aspiration.org"
    And I select "Not-For-Profit" from "Type"
    And I fill in "Description" with "This is a nice NGO."
    And I press "Submit"
    Then I should see "Aspiration"
    And the organization's parent should be "<parent>"

    Examples:
    | parent    |
    |           |
    | Red Cross |

  Scenario: Admin edits an organization
    When I go to the admin dashboard
    And I follow "Organizations"
    When I follow "Red Cross"
    And I fill in "Name" with "Red Cross International"
    And I press "Update"
    Then I should see "Red Cross International"
