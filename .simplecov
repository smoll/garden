require "codeclimate-test-reporter"

# Sending to Coveralls requires no set up, is done by rake task
# Sending to Code Climate is set up here, but pushed in a rake task
# ref: https://github.com/codeclimate/ruby-test-reporter#using-with-parallel_tests
# ref: https://coveralls.zendesk.com/hc/en-us/articles/201769485-Ruby-Rails
SimpleCov.add_filter "vendor"
SimpleCov.formatters = [SimpleCov::Formatter::HTMLFormatter]
SimpleCov.start CodeClimate::TestReporter.configuration.profile

SimpleCov.configure do
  # ignore this file
  add_filter ".simplecov"

  # Changed Files in Git Group
  # ref: http://fredwu.me/post/35625566267/simplecov-test-coverage-for-changed-files-only
  # TODO: fix this
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

  add_group "Scarecrows", "lib/garden/scarecrow"
end
