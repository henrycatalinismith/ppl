
Feature: ppl version

  Scenario: Display the version number
    Given I am in an empty directory
    Then running "ppl version" should output 1 line
    And the 1st line should match "^ppl version \d+\.\d+\.\d+$"

