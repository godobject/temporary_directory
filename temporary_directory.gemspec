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

require 'English'
require_relative 'lib/god_object/temporary_directory/version'

Gem::Specification.new do |gem|
  gem.name    = 'temporary_directory'
  gem.version = GodObject::TemporaryDirectory::VERSION.dup
  gem.authors = ["Alexander E. Fischer"]
  gem.email   = ["aef@godobject.net"]
  gem.description = <<-DESCRIPTION
TemporaryDirectory is a Ruby library that contains a service class that
creates temporary directories and returns Pathname objects to work with them.
Additionally a helper module for RSpec and Cucumber provides temporary
directories for examples and scenarios.
  DESCRIPTION
  gem.summary  = 'Abstractions for creating temporary directories in tests and elsewhere.'
  gem.homepage = 'https://www.godobject.net/'
  gem.license  = 'ISC'
  gem.has_rdoc = 'yard'
  gem.extra_rdoc_files  = %w(HISTORY.md LICENSE.md)
  gem.rubyforge_project = nil

  `git ls-files 2> /dev/null`

  if $CHILD_STATUS.success?
    gem.files         = `git ls-files`.split($\)
  else
    gem.files         = `ls -1`.split($\)
  end

  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = %w(lib)

  gem.required_ruby_version = '>= 2.1.8'

  gem.add_development_dependency('rake')
  gem.add_development_dependency('bundler')
  gem.add_development_dependency('rspec', '~> 3.5')
  gem.add_development_dependency('rspec-collection_matchers', '~> 1.1')
  gem.add_development_dependency('cucumber', '~> 2.4')
  gem.add_development_dependency('simplecov')
  gem.add_development_dependency('pry')
  gem.add_development_dependency('yard')
  gem.add_development_dependency('kramdown')
end
