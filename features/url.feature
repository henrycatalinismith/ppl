
Feature: ppl url

  Scenario: Add a URL to a contact
    Given I am in an address book with a blank contact called bob
    And I run "ppl url bob http://example.org/~bob"
    Then it should succeed
    And bob should have 1 URL
    And the 1st URL should be "http://example.org/~bob"

  Scenario: Remove a URL from a contact
    Given I am in the same address book as before
    And I run "ppl url bob --delete http://example.org/~bob"
    Then it should succeed
    And bob should have 0 URLs

