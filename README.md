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

View code coverage
```
rake && open coverage/index.html
```

View code coverage from RSpec unit tests only
```
rm -rf coverage && rspec && open coverage/index.html
```

## Testing

To test the `garden` binary locally, `cd` to the repo root and run
```
RUBYLIB=lib bundle exec ruby bin/garden
```
Based on [this answer](http://stackoverflow.com/a/23367196/3456726).

## References

#### CLI related

0. http://guides.rubygems.org/make-your-own-gem/
0. http://whatisthor.com/
0. https://github.com/erikhuda/thor/wiki/Integrating-with-Aruba-In-Process-Runs

#### Testing related
0. http://stackoverflow.com/questions/12673485/how-to-test-stdin-for-a-cli-using-rspec
0. https://github.com/livinginthepast/aruba-rspec
0. https://github.com/rapid7/aruba/pull/1/files (Demonstrating simplecov integration)

#### Lint related

0. https://github.com/bbatsov/rubocop/tree/master/lib/rubocop
