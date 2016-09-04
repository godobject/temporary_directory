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

module GodObject
  module TemporaryDirectory

    describe Service do
      describe '#new' do
        it 'requests a temporary directory through the backend_api' do
          backend_api = class_spy(Dir, :backend_api)
          pathname_factory = class_double(Pathname, :pathname_factory).as_null_object
          service = described_class.new(backend_api: backend_api, pathname_factory: pathname_factory)

          service.new

          expect(backend_api).to have_received(:mktmpdir).with(nil, nil)
        end

        context 'when initialized with a name_prefix' do
          it 'requests a prefixed temporary directory through the backend_api' do
            name_prefix = instance_double(String, :name_prefix)
            backend_api = class_spy(Dir, :backend_api)
            pathname_factory = class_double(Pathname, :pathname_factory).as_null_object
            service = described_class.new(backend_api: backend_api,
                                          pathname_factory: pathname_factory,
                                          name_prefix: name_prefix)

            service.new

            expect(backend_api).to have_received(:mktmpdir).with(name_prefix, nil)
          end
        end

        context 'when initialized with a base_directory' do
          it 'requests a temporary directory within the base_directory through the backend_api' do
            base_directory = instance_double(Pathname, :name_prefix)
            backend_api = class_spy(Dir, :backend_api)
            pathname_factory = class_double(Pathname, :pathname_factory).as_null_object
            service = described_class.new(backend_api: backend_api,
                                          pathname_factory: pathname_factory,
                                          base_directory: base_directory)

            service.new

            expect(backend_api).to have_received(:mktmpdir).with(nil, base_directory)
          end
        end

        context 'when initialized with name_prefix and base_directory' do
          it 'requests a prefixed temporary directory within the base_directory through the backend_api' do
            name_prefix = instance_double(String, :name_prefix)
            base_directory = instance_double(Pathname, :name_prefix)
            backend_api = class_spy(Dir, :backend_api)
            pathname_factory = class_double(Pathname, :pathname_factory).as_null_object
            service = described_class.new(backend_api: backend_api,
                                          pathname_factory: pathname_factory,
                                          name_prefix: name_prefix,
                                          base_directory: base_directory)

            service.new

            expect(backend_api).to have_received(:mktmpdir).with(name_prefix, base_directory)
          end
        end

        it 'transforms the temporary directory path into a pathname using the pathname_factory' do
          backend_api = class_double(Dir, :backend_api)
          temporary_directory_path = instance_double(String, :temporary_directory_path)
          allow(backend_api).to receive(:mktmpdir).and_return(temporary_directory_path)
          pathname_factory = class_spy(Pathname, :pathname_factory)
          service = described_class.new(backend_api: backend_api, pathname_factory: pathname_factory)

          service.new

          expect(pathname_factory).to have_received(:new).with(temporary_directory_path)
        end

        it 'returns the pathname' do
          backend_api = class_double(Dir, :backend_api).as_null_object
          pathname_factory = class_double(Pathname, :pathname_factory)
          temporary_directory_pathname = instance_double(Pathname, :temporary_directory_pathname)
          allow(pathname_factory).to receive(:new).and_return(temporary_directory_pathname)
          service = described_class.new(backend_api: backend_api, pathname_factory: pathname_factory)

          result = service.new

          expect(result).to be temporary_directory_pathname
        end
      end
    end

  end
end
