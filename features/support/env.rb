require "aruba/cucumber"
require "aruba/in_process"
require "greens/runner"

Aruba::InProcess.main_class = Greens::Runner
Aruba.process = Aruba::InProcess
