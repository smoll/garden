Feature: lint
  * TODO: eventually, move most, if not all, of these to unit tests

  Scenario: feature text matches, with flexible capitalization
    Given a file named "foo/valid_title.feature" with:
      """
      Feature: Valid Title
      """
    When I run `garden`
    Then the output should contain exactly "1 file(s) inspected, no offenses detected\n"

  Scenario: feature text does not match filename
    Given a file named "foo/mismatched_feature_title.feature" with:
      """
      Feature: mismatched feature title LOL
      """
    When I run `garden`
    Then the output should contain exactly "foo/mismatched_feature_title.feature:1\nFeature: mismatched feature title LOL\n^^^ feature title does not match file name\n\n1 file(s) inspected, 1 offense(s) detected\n"

  Scenario: inconsistent indentation
    Given a file named "foo/indentation.feature" with:
      """
      Feature: indentation

        Scenario: correctly indented

         Scenario: poorly indented
          Then nothing
      """
    When I run `garden`
    Then the output should contain exactly "foo/indentation.feature:5\n   Scenario: poorly indented\n   ^^^ inconsistent indentation detected\n\n1 file(s) inspected, 1 offense(s) detected\n"
