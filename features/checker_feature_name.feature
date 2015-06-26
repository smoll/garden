Feature: (checker) feature name

  Scenario: feature text does not match filename
    Given a file named "foo/mismatched_feature_title.feature" with:
      """
      Feature: mismatched feature title LOL
      """
    When I run `greener`
    Then the output should contain:
      """
      foo/mismatched_feature_title.feature:1
      Feature: mismatched feature title LOL
      ^^^ feature title does not match file name

      1 file(s) inspected, 1 offense(s) detected
      """

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

  Scenario: title case enforced
    Given a file named "foo/this_isnt_title_case_yo.feature" with:
      """
      Feature: this isn't Title Case, yo!
      """
    And a file named "config/enforce_title_case.yml" with:
      """
      Style/FeatureName:
        Enabled: true
        AllowPunctuation: true
        EnforceTitleCase: true
      """
    When I run `greener --config config/enforce_title_case.yml`
    Then the output should contain:
      """
      foo/this_isnt_title_case_yo.feature:1
      Feature: this isn't Title Case, yo!
      ^^^ feature title is not title case. expected: This Isn't Title Case, Yo!

      1 file(s) inspected, 1 offense(s) detected
      """
