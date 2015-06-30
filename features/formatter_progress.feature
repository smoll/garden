Feature: (formatter) progress

  Scenario: happy path
    Given a file named "foo/good.feature" with:
      """
      Feature: good

        Scenario: correctly indented

        Scenario: correctly indented
          Then boom
      """
    Given a file named "foo/good_too.feature" with:
      """
      Feature: good too

        Scenario: correctly indented

        Scenario: correctly indented
          Then boom
      """
    And a file named "config/good.yml" with:
      """
      AllCheckers:
        Formatters:
          - Progress
      """
    When I run `greener --config config/good.yml`
    Then the output should contain:
    """
    ..

    2 file(s) inspected, no offenses detected
    """
