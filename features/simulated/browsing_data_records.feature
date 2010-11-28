Feature: Browsing data records
  So that I can see data records that have been submitted into the data catalog
  As a user
  I want to see a list of data records

  Background:
    Given the following data records exist:
      | title           | lead_organization_name  | collaborator_list | locations      | ministry             | year | tag_list                     | ratings | documents            |
      | Child Birth 1   | Red Cross               | UN, Free Medic    | Afghanistan    | Department of Health | 2009 | health, children, birth rate | 2,3,1   | News Article, Data   |
      | Child Birth 2   | Red Cross               | Amnesty Intl      | Afghanistan    | Department of Health | 2008 | health, children, birth rate | 5,5,4   | Data                 |
      | AIDS 1          | Doctors Without Borders | UN                | Ghana          | Health Department    | 2008 | health, diseases             | 3,2     | Map                  |
      | AIDS 2          | Doctors Without Borders | UN                | South Africa   | Ministry of Health   | 2010 | health, diseases             | 4       | Report               |
      | Malaria         | Red Cross               |                   | Sudan          | Health Ministry      | 2006 | health, diseases, africa     | 1,2     | Other                |
      | Sex Trafficking | AST                     |                   | Cyprus         |                      | 2010 | health, sex, slavery         | 0       | Journal Article, Map |
      | Child Abuse     | United Nations          |                   | Europe         |                      | 2010 | health, children             | 3,3,4,5 | Data, Other          |

  Scenario: Viewing data records on the list without filtering
    Given I am a site visitor
    When I follow "Browse"
    Then I should see "Child Birth"
    And I should see "AIDS"
    And I should see "Malaria"
    And I should see "Sex Trafficking"

  Scenario: Ministry records are listed before community records
    Given I am a site visitor
    When I follow "Browse"
    Then I should see ministry records before community records

  Scenario: Filtering by Location
    Given I am a site visitor
    When I follow "Browse"
    And I select "Afghanistan" from "Location"
    And I press "Filter Data"
    Then I should only see 2 records
    And I should see "Child Birth"
    But I should not see "AIDS"
    And I should not see "Malaria"
    And I should not see "Sex Trafficking"

  Scenario: Filtering by Location includes broader geographical regions
    Given I am a site visitor
    When I follow "Browse"
    And I select "Cyprus" from "Location"
    And I press "Filter Data"
    Then I should only see 2 records
    And I should see "Cyprus"
    And I should see "Europe"
  
  Scenario: Filtering by Ministry
    Given I am a site visitor
    When I follow "Browse"
    And I select "Ministry of Health" from "Ministry/Organization"
    And I press "Filter Data"
    Then I should only see 1 record
    And I should see "AIDS"
    But I should not see "Child Birth"
    And I should not see "Malaria"
    And I should not see "Sex Trafficking"

  Scenario: Filtering by Organization
    Given I am a site visitor
    When I follow "Browse"
    And I select "Red Cross" from "Ministry/Organization"
    And I press "Filter Data"
    Then I should only see 3 records
    And I should see "Child Birth"
    And I should see "Malaria"
    But I should not see "AIDS"
    And I should not see "Sex Trafficking"
    When I select "UN" from "Organization"
    And I press "Filter Data"
    Then I should only see 3 records
    And I should see "Child Birth"
    And I should see "AIDS"
    But I should not see "Malaria"
    And I should not see "Sex Trafficking"

  Scenario: Filtering by Release Year
    Given I am a site visitor
    When I follow "Browse"
    And I select "2006" from "Release Year"
    And I press "Filter Data"
    Then I should only see 1 record
    And I should see "Malaria"
    But I should not see "Child Birth"
    And I should not see "AIDS"
    And I should not see "Sex Trafficking"

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
    And I should not see "Sex Trafficking"

  Scenario: Filtering by tags
    Given I am a site visitor
    When I follow "Browse"
    Then I should see a record tagged "diseases"
    When I follow "diseases"
    Then I should only see 3 records
    And I should see "Browse by tag"
    When I follow "View all"
    Then I should see 7 records

  Scenario Outline: Sorting the data records
    Given I am on the browse page
    When I sort by "<field>" <order>
    Then "<first>" should come before "<second>"
    And "<second>" should come before "<community>"

    Examples:
      | field        | order      | first           | second          | community       |
      | Data Record  | descending | Child Birth 1   | AIDS 1          | Child Abuse     |
      | Data Record  | ascending  | AIDS 1          | Child Birth 1   | Child Abuse     |
      | Rating       | descending | Child Birth 2   | Child Birth 1   | Child Abuse     |
      | Rating       | ascending  | Child Birth 1   | Child Birth 2   | Child Abuse     |
      | Location     | descending | AIDS 2          | Child Birth 2   | Sex Trafficking |
      | Location     | ascending  | Child Birth 2   | AIDS 2          | Sex Trafficking |
      | Ministry     | descending | AIDS 2          | Child Birth 1   | Sex Trafficking |
      | Ministry     | ascending  | Child Birth 1   | AIDS 2          | Sex Trafficking |
      | Organization | descending | AIDS 2          | Child Birth 2   | Child Abuse     |
      | Organization | ascending  | Child Birth 2   | AIDS 2          | Child Abuse     |
      | Formats      | descending | AIDS 2          | Child Birth 2   | Sex Trafficking |
      | Formats      | ascending  | Child Birth 2   | AIDS 2          | Sex Trafficking |
      | Tags         | descending | Child Birth 1   | Malaria         | Child Abuse     |
      | Tags         | ascending  | Malaria         | Child Birth 1   | Child Abuse     |
