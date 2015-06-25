source "https://rubygems.org"

gem "thor", "~> 0.19.1"
gem "gherkin3", github: "smoll/gherkin3", branch: "bundler-fix"

group :debug do
  gem "byebug", "~> 5.0.0"
end

group :test, :development do
  gem "aruba", "~> 0.6.2"
  gem "rake", ">= 0.9.2"
  gem "rspec", "~> 3.3.0"
  gem "rubocop", "~> 0.32.0"

  gem "codeclimate-test-reporter", "~> 0.4.6"
  gem "coveralls", "~> 0.7.9"
  gem "simplecov", "~> 0.9.1"
end
