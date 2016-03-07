Feature: ppl import

  Background:
    Given I have a vcf file called "contacts.vcf" containing the following vcards
      | Name   |
      | Alice  |
      | Bob    |
      | Eve    |

  Scenario: Import several vcards
    Given I am in an empty address book
    And I import "contacts.vcf"
    Then there should be 3 contacts as follows
      | Name   |
      | Alice  |
      | Bob    |
      | Eve    |

