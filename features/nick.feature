
Feature: ppl nick

  Scenario: Add a nickname to a contact
    Given I am in an address book with a blank contact called bob
    And I run "ppl nick bob Bob"
    Then bob should have 1 nickname
    And the 1st nickname should be "Bob"

  Scenario: Remove a nickname address from a contact
    Given I am in the same address book as before
    And I run "ppl nick bob --delete Bob"
    Then bob should have 0 nicknames

