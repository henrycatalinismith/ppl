
Feature: ppl ls

  Scenario: List contacts' names and email addresses
    Given I am in an address book with a blank contact called bob
    And bob's name is "Robert Testing"
    And bob's email address is "bob@example.org"
    Then running "ppl ls" should output 1 line
    And the 1st line should be "bob:  Robert Testing  <bob@example.org>"

