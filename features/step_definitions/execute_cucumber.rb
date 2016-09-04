# frozen_string_literal: true
=begin
Copyright Alexander E. Fischer <aef@godobject.net>, 2016

This file is part of TemporaryDirectory.

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND
FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
PERFORMANCE OF THIS SOFTWARE.
=end

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
