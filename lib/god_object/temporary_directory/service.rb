module GodObject
  module TemporaryDirectory

    class Service
      def initialize(name_prefix: nil, base_directory: nil, backend_api: Dir, pathname_factory: Pathname)
        @name_prefix = name_prefix
        @base_directory = base_directory
        @backend_api = backend_api
        @pathname_factory = pathname_factory
      end

      def new
        path = @backend_api.mktmpdir(@name_prefix, @base_directory)
        @pathname_factory.new(path)
      end
    end

  end
end
