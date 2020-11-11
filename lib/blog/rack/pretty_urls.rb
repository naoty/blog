require 'rack'

module Blog
  module Rack
    # Rack middleware to rewrite URLs to Pretty URLs
    class PrettyURLs
      def initialize(app)
        @app = app
      end

      def call(env)
        env[::Rack::PATH_INFO] += 'index.html' if env[::Rack::PATH_INFO].end_with?('/')
        @app.call(env)
      end
    end
  end
end
