@sources
Feature: Comment on a data record
  In order to share some tips and tricks learned about the data
  As a registered user
  I want to leave some detailed comments about it

  Background:
    Given I am a signed in user
    And a data record titled "Child Birth, crude" exists
    When I go to the data record's page

  Scenario: Leave a comment on the data record
    When I write a comment for the data record
    And I press "Post Comment"
    Then I should see my comment

  Scenario: File a bug report
    When I follow "Report a Problem"
    And I write a bug report for the data record
    And I press "Post Comment"
    Then I should see my bug report

  Scenario: Vote for a nice comment
    Given the data record has two comments with no votes
    When I vote for the first one
    Then the first comment should have 1 vote
    And the second comment should have no votes
