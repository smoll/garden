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
    Then the output should contain exactly "foo/indentation.feature:5\n   Scenario: poorly indented\n   ^^^ inconsistent indentation detected\n\n1 file(s) inspected, 1 offense(s) detected\n"
