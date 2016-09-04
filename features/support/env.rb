# frozen_string_literal: true

require 'temporary_directory'
require 'rspec/collection_matchers'

# For compatibility with Ruby 2.1.x
if RUBY_VERSION.start_with?('2.1')
  class Pathname
    alias / +
  end
end

World(GodObject::TemporaryDirectory::Helper.new(name_prefix: 'temporary_directory_cucumber'))

After do
  ensure_absence_of_temporary_directory
end
