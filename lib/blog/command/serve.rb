require 'rack'

module Blog
  module Command
    # +blog serve+ command
    class Serve
      # @param [Pathname] source the source of Posts
      def initialize(source:)
        @public_path = prepare_public_path
        base_app = ::Rack::Files.new(@public_path)

        @rack_app = ::Rack::Builder.new do
          run base_app
        end
      end

      def run
        copy_static_files(public_path: @public_path)
        start_server
      end

      private

      # @return [Pathname] path to public
      def prepare_public_path
        public_path = Pathname.pwd.join('public')
        public_path.mkdir unless public_path.exist?
        public_path
      end

      # @param [Pathname] public_path path to public
      def copy_static_files(public_path:)
        static_path = Blog.root_path.join('static/.')
        FileUtils.cp_r(static_path, public_path)
      end

      def start_server
        ::Rack::Handler::WEBrick.run(@rack_app)
      end
    end
  end
end
