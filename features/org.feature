
Feature: ppl org

  Scenario: Add an organization to a contact
    Given I am in an address book with a blank contact called bob
    And I run "ppl org bob 'Red Hat'"
    Then bob should have 1 organization
    And the 1st organization should be "Red Hat"

  Scenario: Remove an organization from a contact
    Given I am in the same address book as before
    And I run "ppl org bob --delete 'Red Hat'"
    Then bob should have 0 organizations

