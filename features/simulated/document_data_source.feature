@sources
Feature: Help document a data source
  In order to share my knowledge about a data source
  As a registered user
  I want to edit a wiki-like documentation for the data source

  Background:
    Given a data record titled "The Data Record" exists
    And a user named "John The Documenter" with "john@documenter.com" exists

  Scenario: View an undocumented data record
    Given the data record is not documented
    When I browse to the data record's documentation
    Then I should see "This data source doesn't have any documentation yet."

  Scenario: View a documented data record
    Given the data record is documented
    When I browse to the data record's documentation
    Then I should see the data record's documentation

  Scenario: Edit documentation text
    Given the data record is documented
    And I am a signed in user
    When I browse to the data record's documentation
    And I write the documentation text
    Then I should see the updated documentation
    And I should see 2 versions in the sidebar

  Scenario: Create the first version of the documentation
    Given the data record is not documented
    And I am a signed in user
    When I browse to the data record's documentation
    And I write the documentation text
    Then I should see the updated documentation
    And I should see 1 version in the sidebar

  Scenario: View a past revision of the documentation
    Given the data record was documented 2 times
    When I browse to the data record's documentation
    Then I should see 2 versions in the sidebar
    When I browse to the first revision
    Then I should see the first revision
