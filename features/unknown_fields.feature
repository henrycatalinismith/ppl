Feature: Keep unknown fields when saving

  Scenario: Set a contact's birthday without overwriting their picture
    Given I am in an address book with a blank contact called bob
    And bob has a contact picture
    When I run "ppl bday bob 2000-01-02"
    Then it should succeed
    And bob's birthday should be "2000-01-02"
    And bob still has his contact picture
