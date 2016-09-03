module GodObject
  module TemporaryDirectory

    module Helper
      module_function

      def new(prefix: nil, temporary_directory_service: Dir, pathname_factory: Pathname)
        mixin = Module.new

        mixin.send(:define_method, :temporary_directory_file_name_prefix) do
          prefix
        end

        mixin.send(:define_method, :temporary_directory_service) do
          temporary_directory_service
        end

        mixin.send(:define_method, :temporary_directory_pathname_factory) do
          pathname_factory
        end

        mixin.class_eval do
          def temporary_directory
            ensure_presence_of_temporary_directory
          end

          def ensure_presence_of_temporary_directory
            @temporary_directory ||= create_temporary_directory!
          end

          def ensure_absence_of_temporary_directory
            @temporary_directory.rmtree

            nil
          end

          private

          def create_temporary_directory!
            path = temporary_directory_service.mktmpdir(temporary_directory_file_name_prefix)
            temporary_directory_pathname_factory.new(path)
          end
        end

        mixin
      end
    end

  end
end
