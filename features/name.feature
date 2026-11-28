
Feature: ppl name

  Scenario: Set a contact's full name
    Given I am in an address book with a blank contact called bob
    And I run "ppl name bob 'Robert Testing'"
    Then it should succeed
    And running "ppl name bob" should output 1 line
    And the 1st line should be "Robert Testing"

  Scenario: List contacts' names
    Given I am in the same address book as before
    Then running "ppl name" should output 1 line
    And the 1st line should be "bob:  Robert Testing"

  Scenario: Set the structured parts of a contact's name
    Given I am in the same address book as before
    And I run "ppl name bob --prefix Dr --given Robert --middle Quincy --family Testing --suffix Jr"
    Then it should succeed
    And bob's vcard should include "N:Testing;Robert;Quincy;Dr;Jr"

  Scenario: Fail when the given contact ID doesn't exist
    Given I am in the same address book as before
    And I run "ppl name nobody"
    Then it should fail

