# frozen_string_literal: true

When(/^I run "cucumber ?([^"]*)?"$/) do |arguments|
  create_gemfile(include_gems: %w(cucumber))
  create_root_for_subsequent_temporary_directories

  execute_in_separate_environment(
    %(TMPDIR="#{subsequent_temporary_directory_root_directory}" bundle exec cucumber #{arguments})
  )
end

Then(/^all scenarios and their steps should pass$/) do
  puts output unless $CHILD_STATUS.success?

  expect($CHILD_STATUS).to be_success
  expect(output).not_to match /failed|skipped/
end
