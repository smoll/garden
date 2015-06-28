# Based on https://github.com/cucumber/aruba/blob/master/Rakefile

require "bundler/gem_tasks"
require "rubocop/rake_task"
require "rspec/core/rake_task"
require "cucumber/rake/task"

RuboCop::RakeTask.new

RSpec::Core::RakeTask.new

Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = ""
  t.cucumber_opts << "--format pretty"
end

Cucumber::Rake::Task.new(:cucumber_wip) do |t|
  t.cucumber_opts = "-p wip"
end

namespace :cc do
  task :push do
    require "simplecov"
    require "codeclimate-test-reporter"
    CodeClimate::TestReporter::Formatter.new.format(SimpleCov.result)
  end
end

require "coveralls/rake/task"
Coveralls::RakeTask.new # rake task coveralls:push

desc "Run tests, both RSpec and Cucumber"
task test: [:rubocop, :spec, :cucumber, "coveralls:push", "cc:push"]

task default: :test
