greener
===

[![Circle CI](https://circleci.com/gh/smoll/greener.svg?style=svg)](https://circleci.com/gh/smoll/greener) [![Code Climate](https://codeclimate.com/github/smoll/greener/badges/gpa.svg)](https://codeclimate.com/github/smoll/greener) [![Coverage Status](https://coveralls.io/repos/smoll/greener/badge.svg?branch=master)](https://coveralls.io/r/smoll/greener?branch=master) [![Gem Version](https://badge.fury.io/rb/greener.svg)](http://badge.fury.io/rb/greener)

A Gherkin .feature file linter

**NOTE: This project is still under early-stage development**

## TODOs

0. Move "results printing" logic to configurable formatters
0. Implement some kind of hooks system for use by formatters, similar to [this](https://github.com/bbatsov/rubocop/blob/master/lib/rubocop/formatter/base_formatter.rb#L30-L41)
0. Create a RakeTask class for use in CI systems
0. Add coloring for formatters

## Usage

Install the gem
```
gem install greener
```

The `greener` binary takes a single argument, `-c path/to/config/greener.yml`. See the [defaults](./config/defaults.yml) for an example of this file.

View the [changelog](./CHANGELOG.md) for recent changes.

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

## Testing

To test the `greener` binary locally, `cd` to the repo root and run
```
RUBYLIB=lib bundle exec ruby bin/greener
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

#### Lint related

0. https://github.com/bbatsov/rubocop/tree/master/lib/rubocop
