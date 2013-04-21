
Feature: ppl mutt

  Scenario: Find contacts whose name matches the given string
    Given I am in an address book with a blank contact called bob
    And bob's name is "Robert Testing"
    And bob's email address is "bob@example.org"
    Then running "ppl mutt Rob" should output 2 lines
    And the 1st line should be "Searching address book... 1 email addresses... 1 matching:"
    And the 2nd line should be "bob@example.org	Robert Testing"

  Scenario: Fail to match a name because the case is wrong
    Given I am in the same address book as before
    Then running "ppl mutt rob" should output 1 line
    And the 1st line should be "No matches"

  Scenario: Case-insensitive search
    Given I am in the same address book as before
    Then running "ppl mutt -i rob" should output 2 lines
    And the 1st line should be "Searching address book... 1 email addresses... 1 matching:"
    And the 2nd line should be "bob@example.org	Robert Testing"

