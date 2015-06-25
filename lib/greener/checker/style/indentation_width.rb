require "greener/checker/base"

module Greener
  module Checker
    module Style
      # Ensure keywords are indented correctly
      # Ref: https://github.com/bbatsov/rubocop/commit/44c1cdd5d9bc1c3588ea7841fc6e9543126306e8
      class IndentationWidth < Base
        MSG = "inconsistent indentation detected"

        def run
          return unless @config["Enabled"]

          check_feature_line
          check_every_scenario
        end

        def check_feature_line
          return if feature[:location][:column] == 1
          log_violation(feature[:location][:line], feature[:location][:column])
        end

        def check_every_scenario
          feature[:scenarioDefinitions].each do |scenario|
            scenario[:steps].each { |step| check_a_step(step) }

            next if scenario[:location][:column] == (1 + configured_indentation_width)
            log_violation(scenario[:location][:line], scenario[:location][:column])
          end
        end

        def check_a_step(step) # nil if a scenario has no steps, or
          # {:type=>:Step, :location=>{:line=>6, :column=>5}, :keyword=>"Then ", :text=>"nothing"}
          return if step[:location][:column] == (1 + configured_indentation_width * 2)
          log_violation(step[:location][:line], step[:location][:column])
        end

        def configured_indentation_width
          @config["Width"]
        end
      end
    end
  end
end
