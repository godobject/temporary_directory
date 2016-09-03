module GodObject
  module TemporaryDirectory

    describe Helper do
      describe '.new' do
        it 'returns a module' do
          prefix = instance_double(String, :prefix)
          result = described_class.new(prefix: prefix)

          expect(result).to be_a Module
        end

        describe 'an object extended with the returned mixin module' do
          describe '#temporary_directory' do
            it 'requests a temporary directory through the temporary_directory_service' do
              prefix = instance_double(String, :prefix)
              temporary_directory_service = class_spy(Dir, :temporary_directory_service)
              pathname_factory = class_double(Pathname, :pathname_factory).as_null_object
              result = described_class.new(prefix: prefix,
                                           temporary_directory_service: temporary_directory_service,
                                           pathname_factory: pathname_factory)
              extended_object = build_object(mixin: result)

              extended_object.temporary_directory

              expect(temporary_directory_service).to have_received(:mktmpdir).with(prefix)
            end

            it 'converts the temporary directory path to a pathname using the pathname_factory' do
              temporary_directory_service = class_double(Dir, :temporary_directory_service)
              temporary_directory_path = instance_double(String, :temporary_directory_path)
              pathname_factory = class_spy(Pathname, :pathname_factory)
              allow(temporary_directory_service).to receive(:mktmpdir).and_return(temporary_directory_path)
              result = described_class.new(prefix: build_prefix,
                                           temporary_directory_service: temporary_directory_service,
                                           pathname_factory: pathname_factory)
              extended_object = build_object(mixin: result)

              extended_object.temporary_directory

              expect(pathname_factory).to have_received(:new).with(temporary_directory_path)
            end

            it 'returns the pathname' do
              temporary_directory_service = class_double(Dir, :temporary_directory_service).as_null_object
              pathname_factory = class_double(Pathname, :pathname_factory)
              temporary_directory_pathname = instance_double(Pathname, :temporary_directory_pathname)
              allow(pathname_factory).to receive(:new).and_return(temporary_directory_pathname)
              result = described_class.new(prefix: build_prefix,
                                           temporary_directory_service: temporary_directory_service,
                                           pathname_factory: pathname_factory)
              extended_object = build_object(mixin: result)

              result = extended_object.temporary_directory

              expect(result).to be temporary_directory_pathname
            end

            it 'does only request a temporary directory once when called multiple times' do
              prefix = instance_double(String, :prefix)
              temporary_directory_service = class_spy(Dir, :temporary_directory_service)
              pathname_factory = class_double(Pathname, :pathname_factory).as_null_object
              result = described_class.new(prefix: prefix,
                                           temporary_directory_service: temporary_directory_service,
                                           pathname_factory: pathname_factory)
              extended_object = build_object(mixin: result)

              2.times do
                extended_object.temporary_directory
              end

              expect(temporary_directory_service).to have_received(:mktmpdir).with(prefix)
            end
          end

          describe '#ensure_presence_of_temporary_directory' do
            it 'requests a temporary directory through the temporary_directory_service' do
              prefix = instance_double(String, :prefix)
              temporary_directory_service = class_spy(Dir, :temporary_directory_service)
              pathname_factory = class_double(Pathname, :pathname_factory).as_null_object
              result = described_class.new(prefix: prefix,
                                           temporary_directory_service: temporary_directory_service,
                                           pathname_factory: pathname_factory)
              extended_object = build_object(mixin: result)

              extended_object.ensure_presence_of_temporary_directory

              expect(temporary_directory_service).to have_received(:mktmpdir).with(prefix)
            end

            it 'converts the temporary directory path to a pathname using the pathname_factory' do
              temporary_directory_service = class_double(Dir, :temporary_directory_service)
              temporary_directory_path = instance_double(String, :temporary_directory_path)
              pathname_factory = class_spy(Pathname, :pathname_factory)
              allow(temporary_directory_service).to receive(:mktmpdir).and_return(temporary_directory_path)
              result = described_class.new(prefix: build_prefix,
                                           temporary_directory_service: temporary_directory_service,
                                           pathname_factory: pathname_factory)
              extended_object = build_object(mixin: result)

              extended_object.ensure_presence_of_temporary_directory

              expect(pathname_factory).to have_received(:new).with(temporary_directory_path)
            end

            it 'returns the pathname' do
              temporary_directory_service = class_double(Dir, :temporary_directory_service).as_null_object
              pathname_factory = class_double(Pathname, :pathname_factory)
              temporary_directory_pathname = instance_double(Pathname, :temporary_directory_pathname)
              allow(pathname_factory).to receive(:new).and_return(temporary_directory_pathname)
              result = described_class.new(prefix: build_prefix,
                                           temporary_directory_service: temporary_directory_service,
                                           pathname_factory: pathname_factory)
              extended_object = build_object(mixin: result)

              result = extended_object.ensure_presence_of_temporary_directory

              expect(result).to be temporary_directory_pathname
            end

            it 'does only request a temporary directory once when called multiple times' do
              prefix = instance_double(String, :prefix)
              temporary_directory_service = class_spy(Dir, :temporary_directory_service)
              pathname_factory = class_double(Pathname, :pathname_factory).as_null_object
              result = described_class.new(prefix: prefix,
                                           temporary_directory_service: temporary_directory_service,
                                           pathname_factory: pathname_factory)
              extended_object = build_object(mixin: result)

              2.times do
                extended_object.ensure_presence_of_temporary_directory
              end

              expect(temporary_directory_service).to have_received(:mktmpdir).with(prefix)
            end
          end

          describe '#ensure_absence_of_temporary_directory' do
            it 'commands the pathname to recursively remove the temporary directory' do
              temporary_directory_service = class_double(Dir, :temporary_directory_service).as_null_object
              pathname_factory = class_double(Pathname, :pathname_factory)
              temporary_directory_pathname = instance_spy(Pathname, :temporary_directory_pathname)
              allow(pathname_factory).to receive(:new).and_return(temporary_directory_pathname)
              result = described_class.new(prefix: build_prefix,
                                           temporary_directory_service: temporary_directory_service,
                                           pathname_factory: pathname_factory)
              extended_object = build_object(mixin: result)

              extended_object.ensure_presence_of_temporary_directory
              extended_object.ensure_absence_of_temporary_directory

              expect(temporary_directory_pathname).to have_received(:rmtree).with(no_args)
            end

            it 'does nothing if no temporary directory has been created before' do
              temporary_directory_service = class_double(Dir, :temporary_directory_service).as_null_object
              pathname_factory = class_double(Pathname, :pathname_factory)
              temporary_directory_pathname = instance_spy(Pathname, :temporary_directory_pathname)
              allow(pathname_factory).to receive(:new).and_return(temporary_directory_pathname)
              result = described_class.new(prefix: build_prefix,
                                           temporary_directory_service: temporary_directory_service,
                                           pathname_factory: pathname_factory)
              extended_object = build_object(mixin: result)

              extended_object.ensure_absence_of_temporary_directory

              expect(temporary_directory_pathname).not_to have_received(:rmtree)
            end
          end
        end

        def build_prefix
          instance_double(String, :prefix)
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
