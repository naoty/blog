require 'blog/rack/application'
require 'rack'

module Blog
  module Command
    # +blog serve+ command
    class Serve
      # @param [Pathname] source the source of Posts
      def initialize(source:)
        post_repository = PostRepository.new(source: source)
        @application = Rack::Application.new(post_repository: post_repository)
      end

      def run
        ::Rack::Handler::WEBrick.run(@application)
      end
    end
  end
end
