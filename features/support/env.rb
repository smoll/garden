require "aruba/cucumber"
require "aruba/in_process"
require "garden/runner"

Aruba::InProcess.main_class = Garden::Runner
Aruba.process = Aruba::InProcess
