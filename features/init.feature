
Feature: ppl init

  Scenario: Create a new address book
    Given I am in an empty directory
    When I run "ppl init ./contacts"
    Then it should succeed
    And "./contacts" should be a ppl address book

  Scenario: Incorrect usage
    Given I am in an empty directory
    When I run "ppl init --invalid-option 2> /dev/null"
    Then it should fail

