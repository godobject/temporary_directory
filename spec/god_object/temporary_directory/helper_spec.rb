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

    describe Helper do
      describe '.new' do
        it 'returns a module' do
          name_prefix = instance_double(String, :name_prefix)
          result = described_class.new(name_prefix: name_prefix)

          expect(result).to be_a Module
        end

        describe 'an object extended with the returned mixin module' do
          [:temporary_directory, :ensure_presence_of_temporary_directory].each do |method|
            describe "##{method}" do
              it 'requests a temporary directory through the temporary_directory_service' do
                temporary_directory_service = instance_spy(Service, :temporary_directory_service)
                result = described_class.new(temporary_directory_service: temporary_directory_service)
                extended_object = build_object(mixin: result)

                extended_object.temporary_directory

                expect(temporary_directory_service).to have_received(:new).with(no_args)
              end


              it 'returns the pathname' do
                temporary_directory_service = instance_double(Service, :temporary_directory_service)
                temporary_directory_pathname = instance_double(Pathname, :temporary_directory_pathname)
                allow(temporary_directory_service).to receive(:new).and_return(temporary_directory_pathname)
                result = described_class.new(temporary_directory_service: temporary_directory_service)
                extended_object = build_object(mixin: result)

                result = extended_object.temporary_directory

                expect(result).to be temporary_directory_pathname
              end

              it 'only once requests a temporary directory even when called multiple times' do
                temporary_directory_service = instance_spy(Service, :temporary_directory_service)
                result = described_class.new(temporary_directory_service: temporary_directory_service)
                extended_object = build_object(mixin: result)

                2.times do
                  extended_object.temporary_directory
                end

                expect(temporary_directory_service).to have_received(:new).with(no_args)
              end
            end
          end

          describe '#ensure_absence_of_temporary_directory' do
            it 'commands the pathname to recursively remove the temporary directory' do
              temporary_directory_service = instance_spy(Service, :temporary_directory_service)
              temporary_directory_pathname = instance_spy(Pathname, :temporary_directory_pathname)
              allow(temporary_directory_service).to receive(:new).and_return(temporary_directory_pathname)
              result = described_class.new(temporary_directory_service: temporary_directory_service)
              extended_object = build_object(mixin: result)

              extended_object.ensure_presence_of_temporary_directory
              extended_object.ensure_absence_of_temporary_directory

              expect(temporary_directory_pathname).to have_received(:rmtree).with(no_args)
            end

            it 'does nothing if no temporary directory has been created before' do
              temporary_directory_service = instance_spy(Service, :temporary_directory_service)
              temporary_directory_pathname = instance_spy(Pathname, :temporary_directory_pathname)
              allow(temporary_directory_service).to receive(:new).and_return(temporary_directory_pathname)
              result = described_class.new(temporary_directory_service: temporary_directory_service)
              extended_object = build_object(mixin: result)

              extended_object.ensure_absence_of_temporary_directory

              expect(temporary_directory_pathname).not_to have_received(:rmtree)
            end
          end
        end

        def build_name_prefix
          instance_double(String, :name_prefix)
        end

        def build_object(mixin:)
          object = Object.new
          object.extend(mixin)
          object
        end
      end
    end

  end
end
