
Feature: ppl ls

  Scenario: List contacts' names and email addresses
    Given I am in an address book with a blank contact called bob
    And bob's name is "Robert Testing"
    And bob's email address is "bob@example.org"
    Then running "ppl ls" should output 1 line
    And the 1st line should be "bob:  Robert Testing  <bob@example.org>"

  Scenario: Custom output with %i
    Given I am in the same address book as before
    Then running "ppl ls --format '%i'" should output 1 line
    And the 1st line should be "bob"

  Scenario: Custom output with %N
    Given I am in the same address book as before
    Then running "ppl ls --format '%N'" should output 1 line
    And the 1st line should be "Robert Testing"

  Scenario: Custom output with %e
    Given I am in the same address book as before
    Then running "ppl ls --format '%e'" should output 1 line
    And the 1st line should be "bob@example.org"

