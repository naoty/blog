module Blog
  module Rack
    # Rack middleware to return 404.html when status code is 404
    class NotFound
      def initialize(app)
        @app = app

        path = Pathname.pwd.join('public', '404.html')
        @content = path.read
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
