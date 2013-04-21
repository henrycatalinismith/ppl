
Feature: ppl email

  Scenario: Add an email address to a contact
    Given I am in an address book with a blank contact called bob
    And I run "ppl email bob bob@example.org"
    Then bob should have 1 email address
    And the 1st email address should be "bob@example.org"

  Scenario: Remove an email address from a contact
    Given I am in the same address book as before
    And I run "ppl email bob --delete bob@example.org"
    Then bob should have 0 email addresses

