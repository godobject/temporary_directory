When(/^I run "rspec ([^"]*)"$/) do |arguments|
  create_gemfile(include_gems: %w{rspec})
  create_root_for_subsequent_temporary_directories

  execute_in_separate_environment(
    %(TMPDIR="#{subsequent_temporary_directory_root_directory}" bundle exec rspec #{arguments})
  )
end

Then(/^all examples should pass$/) do
  puts output unless $CHILD_STATUS.success?

  expect($CHILD_STATUS).to be_success
  expect(output).to include '0 failures'
end
