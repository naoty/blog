module Blog
  module Rack
    # Rack middleware to return 404.html when status code is 404
    class NotFound

      # @param [Object] app Rack application to be wrapped
      # @param [String] source The path to directory containing 404.html
      def initialize(app, source:)
        @app = app

        @content = source.join('404.html').read
        @content_length = @content.bytesize.to_s
      end

      def call(env)
        response = @app.call(env)
        return response if response[0] != 404

        [
          404,
          {
            'Content-Length' => @content_length,
            'Content-Type' => 'text/html'
          },
          [@content]
        ]
      end
    end
  end
end
