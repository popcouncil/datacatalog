Feature: Email notification of filtered data records
  In order to receive notifications by email since I prefer that method to be notified
  As a registered user
  I want to receive email messages on newly created data records

  Background:
    Given the following data records exist:
      | title           | lead_organization_name  | collaborator_list | locations      | ministry             | year | tag_list                     | ratings | documents            |
      | Child Birth 1   | Red Cross               | UN, Free Medic    | Afghanistan    | Department of Health | 2009 | health, children, birth rate | 2,3,1   | News Article, Data   |
      | Child Birth 2   | Red Cross               | Amnesty Intl      | Afghanistan    | Department of Health | 2008 | health | 5,5,4   | Data                 |
    And an alert exists
    

  Scenario: Add an alert
    Given I am signed in
    When I go to my profile edit page
    And I select "health" from "alert_tag_id" 
    And I press "Save"
    Then I should see "Successful"

# This needs fixing. Copied from adding_data_source.feature
#  Scenario: A user adds a new data record matching an alert
#    Given I am signed in
#    When I follow "Add Data"
#    And I fill in the data record fields in the first screen
#    And I press "Submit"
#    Then I should see "Tell us who did the work"
#    Then I fill in the data record fields in the second screen
#    And I press "Submit"
#    Then I should see "Your Data has been submitted"
#    And I should receive the "data_record_alert" email
