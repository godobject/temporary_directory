# frozen_string_literal: true

Given(/^a file called "([^"]*)" with the following content:$/) do |relative_path, file_content|
  file = temporary_directory / relative_path
  file.parent.mkpath
  file.write(file_content)
end
