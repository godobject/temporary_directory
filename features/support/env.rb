require 'temporary_directory'
require 'English'
require 'rspec/collection_matchers'

World(GodObject::TemporaryDirectory::Helper.new(prefix: 'temporary_directory_cucumber'))

Before do
  @project_root_directory = Pathname.new(__dir__) / '..' / '..'
end

After do
  ensure_absence_of_temporary_directory
end
