
Feature: ppl grep

  Scenario: Search for matching lines using git grep
    Given I am in an address book with a blank contact called bob
    And bob's name is "Robert Testing"
    And bob's email address is "bob@example.org"
    Then running "ppl grep bob" should output 1 line
    And the 1st line should be "bob.vcf:EMAIL:bob@example.org"

