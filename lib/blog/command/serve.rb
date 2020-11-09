require 'rack'

module Blog
  module Command
    # +blog serve+ command
    class Serve
      # @param [Pathname] source the source of Posts
      def initialize(source:)
        @application = Rack::NotFound.new
      end

      def run
        ::Rack::Handler::WEBrick.run(@application)
      end
    end
  end
end
