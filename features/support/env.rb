require 'temporary_directory'
require 'rspec/collection_matchers'

World(GodObject::TemporaryDirectory::Helper.new(name_prefix: 'temporary_directory_cucumber'))

After do
  ensure_absence_of_temporary_directory
end
