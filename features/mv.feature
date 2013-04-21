
Feature: ppl mv

  Scenario: Change a contact's ID
    Given I am in an address book with a blank contact called bob
    And I run "ppl mv bob rob"
    Then it should succeed
    And there should be 1 contact
    And its ID should be "rob"

  Scenario: Fail when the given contact ID doesn't exist
    Given I am in the same address book as before
    And I run "ppl mv bob rob 2> /dev/null"
    Then it should fail

