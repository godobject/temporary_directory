When(/^I run "cucumber ?([^"]*)?"$/) do |arguments|
  gemfile = temporary_directory / 'Gemfile'
  gemfile.write(<<~GEMFILE)
    gem 'temporary_directory', path: '#{@project_root_directory}'
    gem 'cucumber', '= #{Gem.loaded_specs['cucumber'].version}'
  GEMFILE

  @subsequent_temporary_directory_root_directory = temporary_directory / 'subsequent_temporary_directories'
  @subsequent_temporary_directory_root_directory.mkpath

  Bundler.with_clean_env do
    Dir.chdir(temporary_directory) do
      @output = `TMPDIR="#{@subsequent_temporary_directory_root_directory}" bundle exec cucumber #{arguments}`
    end
  end
end

Then(/^all scenarios and their steps should pass$/) do
  unless $CHILD_STATUS.success?
    puts @output
  end

  expect($CHILD_STATUS).to be_success
  expect(@output).not_to match /failed|skipped/
end
