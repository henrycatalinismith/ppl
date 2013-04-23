
Feature: ppl phone

  Scenario: Add a phone number to a contact
    Given I am in an address book with a blank contact called bob
    And I run "ppl phone bob 01234567890"
    Then it should succeed
    And bob should have 1 phone number
    And the 1st phone number should be "01234567890"

  Scenario: Update a phone number's type
    Given I am in the same address book as before
    And I run "ppl phone bob 01234567890 --type cell"
    Then it should succeed
    And bob should have 1 phone number
    And the 1st phone number should be "01234567890  (cell)"

  Scenario: Remove a phone number's type
    Given I am in the same address book as before
    And I run "ppl phone bob 01234567890 --type ''"
    Then it should succeed
    And bob should have 1 phone number
    And the 1st phone number should be "01234567890"

  Scenario: Set an existing phone number as the preferred number
    Given I am in the same address book as before
    And I run "ppl phone bob 01234567890 --preferred"
    Then it should succeed
    And bob should have 1 phone number
    And "01234567890" should be the preferred phone number

  Scenario: Remove the preferred flag from a phone number
    Given I am in the same address book as before
    And I run "ppl phone bob -P 01234567890"
    Then it should succeed
    And bob should have 1 phone number
    And there should be no preferred phone number

  Scenario: Remove a phone number from a contact
    Given I am in the same address book as before
    And I run "ppl phone bob --delete 01234567890"
    Then it should succeed
    And bob should have 0 phone numbers

