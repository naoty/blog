require 'blog/rack/application'
require 'rack'

module Blog
  module Command
    # +blog serve+ command
    class Serve
      def initialize
        @application = Rack::Application.new
      end

      def run
        ::Rack::Handler::WEBrick.run(@application)
      end
    end
  end
end
