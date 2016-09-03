Then(/^no temporary directories remain$/) do
  expect(@subsequent_temporary_directory_root_directory).to have(0).children
end

Then(/^one temporary directory remains$/) do
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
