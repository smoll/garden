## 0.2.0 (March 28, 2018)

Chores:

  - Fix parser errors by updating to newer version of the `gherkin` gem. Fixes [#34](https://github.com/smoll/greener/issues/34).


## 0.1.0 (June 29, 2015)

Features:

  - First minor version release
  - 2 checkers are available, `Style/FeatureName` and `Style/IndentationWidth`
  - By default, `greener` checks for .feature files recursively from the current working directory. This can be overridden via the `AllCheckers:` > `Include:` or `Exclude:` keys in the yml.
