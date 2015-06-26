Feature: lint

  Scenario: multiple issues
    Given a file named "foo/multiple_issues.feature" with:
      """
       Feature: multiple issues

        Scenario: correctly indented

         Scenario: poorly indented
          Then nothing
      """
    When I run `greener`
    Then the output should contain "1 file(s) inspected, 2 offense(s) detected\n"
