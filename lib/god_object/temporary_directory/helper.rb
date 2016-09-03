module GodObject
  module TemporaryDirectory

    module Helper
      def self.new(name_prefix: nil,
                   base_directory: nil,
                   temporary_directory_service: Service.new(name_prefix: name_prefix, base_directory: base_directory))

        mixin = Module.new do
          include Helper
        end

        mixin.send(:define_method, :temporary_directory_service) do
          temporary_directory_service
        end

        mixin
      end

      def temporary_directory
        ensure_presence_of_temporary_directory
      end

      def ensure_presence_of_temporary_directory
        @temporary_directory ||= create_temporary_directory!
      end

      def ensure_absence_of_temporary_directory
        @temporary_directory&.rmtree

        nil
      end

      private

      def create_temporary_directory!
        temporary_directory_service.new
      end
    end

  end
end
