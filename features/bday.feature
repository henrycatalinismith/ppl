
Feature: ppl bday

  Scenario: Set a contact's birthday
    Given I am in an address book with a blank contact called bob
    And I run "ppl bday bob 2000-01-02"
    Then bob's birthday should be "2000-01-02"
