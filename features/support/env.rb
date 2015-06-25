require "simplecov"
require "aruba/cucumber"
require "aruba/in_process"
require "garden/runner"

SimpleCov.command_name ENV["SIMPLECOV_COMMAND_NAME"]

Aruba::InProcess.main_class = Garden::Runner
Aruba.process = Aruba::InProcess

Before do |scenario|
  command_name = case scenario
                 when Cucumber::RunningTestCase::Scenario, Cucumber::RunningTestCase::ScenarioOutline
                   "#{scenario.feature.title} #{scenario.name}"
                 when Cucumber::RunningTestCase::OutlineTable::ExampleRow
                   scenario_outline = scenario.scenario_outline

                   "#{scenario_outline.feature.title} #{scenario_outline.name} #{scenario.name}"
                 else
                   fail TypeError, "Don't know how to extract command name from #{scenario.class}"
                 end

  set_env("SIMPLECOV_COMMAND_NAME", "cucumber #{command_name}")
end
