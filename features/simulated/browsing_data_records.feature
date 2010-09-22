Feature: Browsing data records
  So that I can see data records that have been submitted into the data catalog
  As a user
  I want to see a list of data records

  Background:
    Given the following data records exist:
      | title        | organization            | country      | ministry             | year |
      | Child Birth  | Red Cross               | Afghanistan  | Department of Health | 2009 |
      | Child Birth  | Red Cross               | Afghanistan  | Department of Health | 2008 |
      | AIDS         | Doctors Without Borders | Ghana        | Health Department    | 2008 |
      | AIDS         | Doctors Without Borders | South Africa | Ministry of Health   | 2010 |
      | Malaria      | Red Cross               | Sudan        | Health Ministry      | 2006 |

  Scenario: Viewing data records on the list without filtering
    Given I am a site visitor
    When I follow "Browse"
    Then I should see "Child Birth"
    And I should see "AIDS"
    And I should see "Malaria"

  Scenario: Filtering by Location
    Given I am a site visitor
    When I follow "Browse"
    And I select "Afghanistan" from "Location"
    And I press "Filter Data"
    Then I should only see 2 records
    And I should see "Child Birth"
    But I should not see "AIDS"
    And I should not see "Malaria"

  Scenario: Filtering by Ministry
    Given I am a site visitor
    When I follow "Browse"
    And I select "Ministry of Health" from "Ministry"
    And I press "Filter Data"
    Then I should only see 1 record
    And I should see "AIDS"
    But I should not see "Child Birth"
    And I should not see "Malaria"

  Scenario: Filtering by Organization
    Given I am a site visitor
    When I follow "Browse"
    And I select "Red Cross" from "Organization"
    And I press "Filter Data"
    Then I should only see 3 records
    And I should see "Child Birth"
    And I should see "Malaria"
    But I should not see "AIDS"

  Scenario: Filtering by Release Year
    Given I am a site visitor
    When I follow "Browse"
    And I select "2006" from "Release Year"
    And I press "Filter Data"
    Then I should only see 1 record
    And I should see "Malaria"
    But I should not see "Child Birth"
    And I should not see "AIDS"

  Scenario: Filtering by more than one criteria
    Given I am a site visitor
    When I follow "Browse"
    And I select "2008" from "Release Year"
    And I select "Doctors Without Borders" from "Organization"
    And I press "Filter Data"
    Then I should only see 1 record
    And I should see "AIDS"
    But I should not see "Child Birth"
    And I should not see "Malaria"
