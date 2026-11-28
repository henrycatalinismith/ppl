
Feature: ppl help

  Scenario: List the available commands
    Given I am in an empty directory
    And I run "ppl help"
    Then it should succeed
    And running "ppl help" should output a line matching "^   add +Add a new contact$"

