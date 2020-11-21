require 'rack'

module Blog
  module Command
    # +blog serve+ command
    class Serve
      attr_reader :source

      # @param [Pathname] source the source of Posts
      def initialize(source:)
        @source = source
      end

      def run
        copy_static_files
        start_server
      end

      private

      # @param [Pathname] public_path path to public
      def copy_static_files
        static_path = Blog.root_path.join('static/.')
        FileUtils.cp_r(static_path, Blog.public_path)
      end

      def start_server
        ::Rack::Handler::WEBrick.run(rack_app)
      end

      def rack_app
        @rack_app ||= ::Rack::Builder.new do
          use Rack::NotFound
          use Rack::PostsBuild, path: '/', source: source
          use Rack::PostBuild, path: %r{/(?<id>\d+)/}, source: source
          use Rack::PrettyURLs
          run base_app
        end
      end

      def base_app
        @base_app ||= ::Rack::Files.new(Blog.public_path)
      end
    end
  end
end
