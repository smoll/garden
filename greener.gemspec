# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "greener/version"

Gem::Specification.new do |spec|
  spec.name          = "greener"
  spec.version       = Greener::VERSION
  spec.authors       = ["smoll"]
  spec.email         = ["smollah@theorchard.com"]

  spec.summary       = "A Gherkin .feature file linter"
  spec.description   = "Keep your Gherkin readable with the greener linter..."
  spec.homepage      = "https://github.com/smoll/greener"
  spec.license       = "MIT"

  spec.files = `git ls-files`.split($RS).reject do |file|
    file =~ %r{^(?:
    spec/.*
    |\.gitignore
    |\.rspec
    |\.rubocop.yml
    |\.rubocop_todo.yml
    |\.simplecov
    |circle.yml
    |cucumber.yml
    |Gemfile
    |Rakefile
    )$}x
  end
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "gherkin3", "~> 3.1.1"
  spec.add_dependency "rainbow", "~> 2.0.0"
  spec.add_dependency "thor", "~> 0.19.1"
  spec.add_dependency "titleize", "~> 1.3.0"

  spec.add_development_dependency "aruba", "~> 0.6.2"
  spec.add_development_dependency "bundler", ">= 1.9.5"
  spec.add_development_dependency "codeclimate-test-reporter", "~> 0.4.6"
  spec.add_development_dependency "coveralls", "~> 0.7.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.3.0"
  spec.add_development_dependency "rubocop", "~> 0.32.0"
  spec.add_development_dependency "simplecov", "~> 0.9.1"
end
