
Feature: ppl post

  Scenario: Add a home postal address to a contact
    Given I am in an address book with a blank contact called bob
    And I run "ppl post bob home --street '1234 Testing Avenue' --postal-code 'AB1 2CD'"
    Then it should succeed
    And bob should have 1 postal address
    And the 1st postal address should be "home  1234 Testing Avenue, AB1 2CD"

  Scenario: Add a work postal address to a contact
    Given I am in the same address book as before
    And I run "ppl post bob work --street '987 Working Road' --postal-code 'EF3 4GH'"
    Then it should succeed
    And bob should have 2 postal addresses
    And the 2nd postal address should be "   work  987 Working Road, EF3 4GH"

  Scenario: Mark an existing postal address as preferred
    Given I am in the same address book as before
    And I run "ppl post bob work --preferred"
    Then it should succeed
    And bob should have 2 postal addresses
    And "work" should be the preferred postal address

