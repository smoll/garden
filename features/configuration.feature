Feature: configuration

  Scenario: disable scarecrow via config file
    Given a file named "foo/mismatched_feature_title.feature" with:
      """
      Feature: mismatched feature title LOL
      """
    And a file named "config/disabled.yml" with:
      """
      Style/FeatureName:
        Enabled: false
      """
    When I run `garden --config config/disabled.yml`
    Then the output should contain exactly "1 file(s) inspected, no offenses detected\n"

  Scenario: invalid scarecrow specified in config
    Given a file named "foo/something.feature" with:
      """
      Feature: something
      """
    And a file named "config/invalid.yml" with:
      """
      Style/NotEvenReal:
        Enabled: false
      """
    When I run `garden --config config/invalid.yml`
    Then the output should contain exactly "Unknown scarecrow specified: Style/NotEvenReal\n"

  Scenario: complex configuration
    Given a file named "foo/indentation_too.feature" with:
      """
      Feature: BAD NAME LOL

          Scenario: correctly indented

          Scenario: correctly indented
              Then boom
      """
    And a file named "config/complex.yml" with:
      """
      Style/FeatureName:
        Enabled: false

      Style/IndentationWidth:
        Enabled: true
        Width: 4
      """
    When I run `garden --config config/complex.yml`
    Then the output should contain exactly "1 file(s) inspected, no offenses detected\n"
