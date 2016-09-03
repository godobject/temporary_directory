require 'tmpdir'
require 'pathname'
require 'English'
require 'rspec/collection_matchers'

Before do
  @temporary_directory = Pathname.new(Dir.mktmpdir('temporary_directory_cucumber'))
  @project_root_directory = Pathname.new(__dir__) / '..' / '..'
end

After do
  @temporary_directory.rmtree
end

Given(/^a file called "([^"]*)" with the following content:$/) do |file_name, file_content|
  file = @temporary_directory / file_name
  file.write(file_content)
end

When(/^I run "rspec ([^"]*)"$/) do |command|
  gemfile = @temporary_directory / 'Gemfile'
  gemfile.write(<<~GEMFILE)
    gem 'temporary_directory', path: '#{@project_root_directory}'
    gem 'rspec', '~> 3.5'
  GEMFILE

  @subsequent_temporary_directory_root_directory = @temporary_directory / 'subsequent_temporary_directories'
  @subsequent_temporary_directory_root_directory.mkpath

  Bundler.with_clean_env do
    Dir.chdir(@temporary_directory) do
      @output = `TMPDIR="#{@subsequent_temporary_directory_root_directory}" bundle exec rspec #{command}`
    end
  end
end

Then(/^all examples should pass$/) do
  unless $CHILD_STATUS.success?
    puts @output
  end

  expect($CHILD_STATUS).to be_success
  expect(@output).to include '0 failures'
end

Then(/^no temporary directories remain$/) do
  expect(@subsequent_temporary_directory_root_directory).to have(0).children
end

Then(/^one temporary directories remains$/) do
  expect(@subsequent_temporary_directory_root_directory).to have(1).children
end

Then(/^(\d+) temporary directories remain$/) do |amount_of_remaining_directories|
  amount_of_remaining_directories = Integer(amount_of_remaining_directories)

  expect(@subsequent_temporary_directory_root_directory).to have(amount_of_remaining_directories).children
end

Then(/^the remaining temporary directories start with "([^"]*)"$/) do |prefix|
  expect(@subsequent_temporary_directory_root_directory).to have_at_least(1).children

  remaining_file_names = @subsequent_temporary_directory_root_directory
                           .children
                           .map(&:basename)
                           .map(&:to_s)

  expect(remaining_file_names).to all(start_with(prefix))
end
