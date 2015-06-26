require "greener/checker/base"
require "titleize"

module Greener
  module Checker
    module Style
      # Ensure .feature filename matches feature name in the Gherkin
      # e.g. filename_of_feature.feature => "Feature: filename of feature"
      class FeatureName < Base
        MSG = "feature title does not match file name"

        def run
          return unless @config["Enabled"]

          run_against_filename
          run_against_titlecase
        end

        def run_against_filename
          filename_without_extension = File.basename(@path, ".*")
          expected = feature[:name]
          expected = expected.gsub(/[^0-9a-z ]/i, "") if allow_punctuation?
          expected = expected.downcase.gsub(" ", "_")
          return if filename_without_extension == expected
          log_violation(feature[:location][:line], feature[:location][:column])
        end

        def run_against_titlecase
          return unless enforce_title_case?
          return if feature[:name].titlecase == feature[:name]
          log_violation(
            feature[:location][:line],
            feature[:location][:column],
            "feature title is not title case. expected: #{feature[:name].titlecase}"
          )
        end

        def allow_punctuation?
          @config["AllowPunctuation"]
        end

        def enforce_title_case?
          @config["EnforceTitleCase"]
        end
      end
    end
  end
end
