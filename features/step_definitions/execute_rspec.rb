When(/^I run "rspec ([^"]*)"$/) do |arguments|
  gemfile = temporary_directory / 'Gemfile'
  gemfile.write(<<~GEMFILE)
    gem 'temporary_directory', path: '#{@project_root_directory}'
    gem 'rspec', '= #{Gem.loaded_specs['rspec'].version}'
  GEMFILE

  @subsequent_temporary_directory_root_directory = temporary_directory / 'subsequent_temporary_directories'
  @subsequent_temporary_directory_root_directory.mkpath

  Bundler.with_clean_env do
    Dir.chdir(temporary_directory) do
      @output = `TMPDIR="#{@subsequent_temporary_directory_root_directory}" bundle exec rspec #{arguments}`
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
