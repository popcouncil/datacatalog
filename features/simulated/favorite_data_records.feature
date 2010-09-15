Feature: Marking data records as favorites
  So that I see the data records that I selected as favorites
  As a registered user 
  I want to select a data record as a favorite

  Background:
    Given I am a signed in user
    And a data record titled "The Data Record" exists

  @javascript
  Scenario: I mark a record as a favorite
    When I go to the data record's page
    And I follow "Favorite this Data Source"
    Then I should see "Current Favorite"
    And I should see "Remove as Favorite"

  @javascript
  Scenario: I unmark a record as a favorite
    Given I favorited the data record
    When I go to the data record's page
    And I follow "Remove as Favorite"
    Then I should see "Favorite this Data"
    And I should see "Favorite this Data Source"

  Scenario: Favorite records show up in the dashboard
    Given I favorited the data record
    When I go to my dashboard
    Then I should see "The Data Record"
