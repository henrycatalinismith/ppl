
Feature: ppl show

  Scenario: Show a contact's details
    Given I am in an address book with a blank contact called bob
    And bob's name is "Robert Testing"
    And bob's email address is "bob@example.org"
    And I run "ppl bday bob 2000-01-02"
    Then running "ppl show bob" should output 6 lines
    And the 1st line should be "Robert Testing <bob@example.org>"
    And the 3rd line should be "  Birthday     2000-01-02"
    And the 5th line should be "Email Addresses:"
    And the 6th line should be "   bob@example.org"

  Scenario: Fail when the given contact ID doesn't exist
    Given I am in the same address book as before
    And I run "ppl show nobody"
    Then it should fail

