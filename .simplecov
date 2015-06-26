require "codeclimate-test-reporter"
require "coveralls"

# https://coderwall.com/p/vwhuqq/using-code-climate-s-new-test-reporter-together-with-coveralls-and-simplecov-s-html-formatter
SimpleCov.formatters = [
  Coveralls::SimpleCov::Formatter,
  CodeClimate::TestReporter::Formatter,
  SimpleCov::Formatter::HTMLFormatter
]

SimpleCov.start do
  # ignore this file
  add_filter ".simplecov"
  add_filter "vendor"
  add_filter "spec/support/matchers"

  # Changed Files in Git Group
  # ref: http://fredwu.me/post/35625566267/simplecov-test-coverage-for-changed-files-only
  untracked = `git ls-files --exclude-standard --others`
  unstaged = `git diff --name-only`
  staged = `git diff --name-only --cached`
  all = untracked + unstaged + staged
  changed_filenames = all.split("\n")

  add_group "Changed" do |source_file|
    changed_filenames.detect do |changed_filename|
      source_file.filename.end_with?(changed_filename)
    end
  end

  add_group "Checkers", "lib/greener/checker"

  # Specs are reported on to ensure that all examples are being run and all
  # lets, befores, afters, etc are being used.
  add_group "Specs", "spec"
end
