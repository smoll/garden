require "simplecov"
require "aruba/cucumber"
require "aruba/in_process"
require "greener/runner"

SimpleCov.command_name "features"

Aruba::InProcess.main_class = Greener::Runner
Aruba.process = Aruba::InProcess
