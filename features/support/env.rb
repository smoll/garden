require "simplecov"
require "aruba/cucumber"
require "aruba/in_process"
require "greener/runner"

Aruba::InProcess.main_class = Greener::Runner
Aruba.process = Aruba::InProcess
