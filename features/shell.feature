
Feature: ppl shell

  Scenario: Run commands read from standard input
    Given I am in an address book with a blank contact called bob
    And bob's name is "Robert Testing"
    When I run "ppl shell" with this input:
      """
      ls
      name bob
      """
    Then it should succeed
    And it should output 2 lines
    And the 1st line should be "bob:  Robert Testing"
    And the 2nd line should be "Robert Testing"

