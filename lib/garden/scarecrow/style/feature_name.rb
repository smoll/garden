module Garden
  module Scarecrow
    module Style
      # Ensure .feature filename matches feature name in the Gherkin
      # e.g. filename_of_feature.feature => "Feature: filename of feature"
      # TODO: add config option for toggling flexible capitalization
      class FeatureName
        MSG = "feature title does not match file name"

        # Returns nil if no violation, or if there is one:
        # { line: 1, column: 1, text_of_line: "Feature: thing", message: "feature title does not match file name" }
        def run(parsed, path)
          file_name_only = File.basename(path, ".*")
          return if parsed[:name].downcase.gsub(" ", "_") == file_name_only

          res = {}
          res[:line] = parsed[:location][:line]
          res[:column] = parsed[:location][:column]
          res[:text_of_line] = "#{parsed[:keyword]}: #{parsed[:name]}" # TODO: get actual line contents
          res[:message] = MSG
          res
        end
      end
    end
  end
end
