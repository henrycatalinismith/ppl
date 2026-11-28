
Feature: ppl completion

  Scenario: Output the bash completion script
    Given I am in an empty directory
    And I run "ppl completion bash"
    Then it should succeed

  Scenario: Output the zsh completion script
    Given I am in an empty directory
    And I run "ppl completion zsh"
    Then it should succeed

  Scenario: Fail for an unsupported shell
    Given I am in an empty directory
    And I run "ppl completion fish"
    Then it should fail

