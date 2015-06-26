Feature: (checker) feature name

  Scenario: feature text does not match filename
    Given a file named "foo/mismatched_feature_title.feature" with:
      """
      Feature: mismatched feature title LOL
      """
    When I run `greener`
    Then the output should contain exactly "foo/mismatched_feature_title.feature:1\nFeature: mismatched feature title LOL\n^^^ feature title does not match file name\n\n1 file(s) inspected, 1 offense(s) detected\n"

  Scenario: capitalization allowed
    Given a file named "foo/valid_title.feature" with:
      """
      Feature: Valid Title
      """
    When I run `greener`
    Then the output should contain exactly "1 file(s) inspected, no offenses detected\n"

  Scenario: punctuation allowed
    Given a file named "foo/some_punctuation.feature" with:
      """
      Feature: (some) punctuation
      """
    And a file named "config/punctuation_allowed.yml" with:
      """
      Style/FeatureName:
        Enabled: true
        AllowPunctuation: true
      """
    When I run `greener --config config/punctuation_allowed.yml`
    Then the output should contain exactly "1 file(s) inspected, no offenses detected\n"
