
Feature: ppl email

  Scenario: Add an email address to a contact
    Given I am in an address book with a blank contact called bob
    And I run "ppl email bob bob@example.org"
    Then it should succeed
    And bob should have 1 email address
    And the 1st email address should be "bob@example.org"

  Scenario: Add a second email address to a contact
    Given I am in the same address book as before
    And I run "ppl email bob rob@testing.com"
    Then it should succeed
    And bob should have 2 email addresses
    And the 1st email address should be "bob@example.org"
    And the 2nd email address should be "rob@testing.com"

  Scenario: Set an existing email address as the preferred address
    Given I am in the same address book as before
    And I run "ppl email bob --preferred rob@testing.com"
    Then it should succeed
    And bob should have 2 email addresses
    And "rob@testing.com" should be the favourite email address

  Scenario: Choose a different preferred email address
    Given I am in the same address book as before
    And I run "ppl email bob --preferred bob@example.org"
    Then it should succeed
    And bob should have 2 email addresses
    And "bob@example.org" should be the favourite email address

  Scenario: Remove the preferred flag from an email address
    Given I am in the same address book as before
    And I run "ppl email bob --not-preferred bob@example.org"
    Then it should succeed
    And bob should have 2 email addresses
    And there should be no favourite email address

  Scenario: Remove email addresses from a contact
    Given I am in the same address book as before
    And I run "ppl email bob --delete bob@example.org"
    And I run "ppl email bob --d rob@testing.com"
    Then it should succeed
    And bob should have 0 email addresses

