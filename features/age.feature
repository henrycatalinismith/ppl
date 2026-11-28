
Feature: ppl age

  Scenario: List contacts' ages
    Given I am in an address book with a blank contact called bob
    And bob's birthday was 30 years ago today
    Then running "ppl age" should output 1 line
    And the 1st line should be "bob:  30"

  Scenario: Show a contact's age
    Given I am in the same address book as before
    Then running "ppl age bob" should output 1 line
    And the 1st line should be "30"

