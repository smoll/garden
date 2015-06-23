# Based on https://github.com/cucumber/aruba/blob/master/Rakefile

require "rubocop/rake_task"
require "cucumber/rake/task"

RuboCop::RakeTask.new

Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = ""
  t.cucumber_opts << "--format pretty"
end

Cucumber::Rake::Task.new(:cucumber_wip) do |t|
  t.cucumber_opts = "-p wip"
end

desc "Run tests, both (todo) RSpec and Cucumber"
task test: [:rubocop, :cucumber, :cucumber_wip]

task default: :test
