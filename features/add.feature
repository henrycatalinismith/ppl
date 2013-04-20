
Feature: ppl add

  Scenario: Add a new contact
    Given I am in an empty address book
    And I run "ppl add alice 'Alice Adams'"
    Then there should be 1 contact
    And its name should be "Alice Adams"

