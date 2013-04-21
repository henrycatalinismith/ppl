
Feature: ppl rm

  Scenario: Remove a contact from the address book
    Given I am in an address book with a blank contact called bob
    And I run "ppl rm bob"
    Then there should be 0 contacts

  Scenario: Fail when asked to remove a non-existent contact
    Given I am in the same address book as before
    And I run "ppl rm bob 2> /dev/null"
    Then it should fail

