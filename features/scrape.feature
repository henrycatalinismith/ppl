
Feature: ppl scrape

  Scenario: Add an email's sender as a new contact
    Given I am in an empty address book
    When I run "ppl scrape --quiet --sender" with this input:
      """
      From: Alice Adams <alice@example.org>
      To: bob@example.org
      Subject: Hello

      Hi Bob
      """
    Then running "ppl ls" should output 1 line
    And the 1st line should be "alice_adams:  Alice Adams  <alice@example.org>"

  Scenario: Avoid clashing with an existing contact ID
    Given I am in the same address book as before
    When I run "ppl scrape -qs" with this input:
      """
      From: Alice Adams <alice2@example.org>

      Hi again
      """
    Then running "ppl ls" should output 2 lines
    And the 2nd line should be "alice_adams_1:  Alice Adams  <alice2@example.org>"

  Scenario: Use the email address as the ID when there's no display name
    Given I am in an empty address book
    When I run "ppl scrape -qs" with this input:
      """
      From: carol@example.org

      Hello
      """
    Then running "ppl email carol@example.org" should output 1 line
    And the 1st line should be "carol@example.org"

