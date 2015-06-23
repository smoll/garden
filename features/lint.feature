@wip
Feature: lint

  Scenario: feature text matches, with flexible capitalization
    Given a file named "foo/valid_title.feature" with:
      """
      Feature: Valid Title
      """
    When I run `greens`
    Then the output should contain exactly "No issues found."

  Scenario: feature text does not match filename
    Given a file named "foo/mismatched_feature_title.feature" with:
      """
      Feature: mismatched feature title LOL
      """
    When I run `greens`
    Then the output should contain exactly "Feature: mismatched feature title LOL\n^^^feature title does not match file name"
