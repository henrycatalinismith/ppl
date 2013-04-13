
Feature: create address book

  Scenario: success
    Given I am in an empty directory
    When I run "ppl init ./contacts"
    Then "./contacts" should be a ppl address book

