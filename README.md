garden
===

[![Circle CI](https://circleci.com/gh/smoll/garden.svg?style=svg)](https://circleci.com/gh/smoll/garden)

Simple Gherkin .feature file linter

**NOTE: This project is still under early-stage development**

## TODOs

0. Improve SoC (`Linter` class does not need to know about #print_results, #parse_single_file should be broken up)
0. Standardize `Scarecrow` options
0. Improve `Scarecrow::Base` constructor method signature
0. Move "results printing" logic to configurable formatters
0. Implement some kind of hooks system for use by formatters, similar to [this](https://github.com/bbatsov/rubocop/blob/master/lib/rubocop/formatter/base_formatter.rb#L30-L41)
0. Create a RakeTask class for use in CI systems
0. Add coloring for formatters

## Contributing

Install dev dependencies locally
```
bundle install
```

Run tests
```
bundle exec rake test
```

## Testing

To test the `garden` binary locally, `cd` to the repo root and run
```
bundle exec ruby -Ilib ./bin/garden help
```

## References

#### CLI related

0. http://guides.rubygems.org/make-your-own-gem/
0. http://whatisthor.com/
0. https://github.com/erikhuda/thor/wiki/Integrating-with-Aruba-In-Process-Runs

#### Lint related

0. https://github.com/bbatsov/rubocop/tree/master/lib/rubocop
