module Blog
  module Rack
    # Rack application to render 404 page
    class NotFound
      def initialize
        @content = Blog.root_path.join('static', '404.html').read
        @length = @content.bytesize.to_s
      end

      def call(_env)
        [
          404,
          { 'Content-Type' => 'text/html', 'Content-Length' => @length },
          [@content]
        ]
      end
    end
  end
end
