
Feature: ppl remote

  Scenario: Pass through to git remote
    Given I am in an empty address book
    And I run "ppl remote add origin https://example.org/contacts.git"
    Then it should succeed
    And running "ppl remote -v" should output 2 lines
    And the 1st line should be "origin	https://example.org/contacts.git (fetch)"

