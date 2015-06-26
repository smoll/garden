Feature: (checker) indentation width

  Scenario: inconsistent indentation
    Given a file named "foo/indentation.feature" with:
      """
      Feature: indentation

        Scenario: correctly indented

         Scenario: poorly indented
          Then nothing
      """
    When I run `greener`
    Then the output should contain:
      """
      foo/indentation.feature:5
         Scenario: poorly indented
         ^^^ inconsistent indentation detected

      1 file(s) inspected, 1 offense(s) detected
      """
