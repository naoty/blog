module Blog
  module Rack
    # Rack middleware to build posts page on demand
    class PostsBuild
      attr_reader :app, :path, :source

      # @param [Object] app Rack application to be wrapped
      # @param [String] path The path of URL this middleware handle requests
      # @param [Pathname] source The path to source directory
      def initialize(app, path:, source:)
        @app = app
        @path = path
        @source = source
      end

      def call(env)
        build_page if env[::Rack::PATH_INFO] == path
        app.call(env)
      end

      private

      def build_page
        posts = post_repository.all_posts_sorted_by_time
        html = posts_renderer.render(posts)
        Blog.public_path.join('index.html').open('wb') { |file| file.puts(html) }
      end

      def post_repository
        @post_repository ||= PostRepository.new(source: source)
      end

      def posts_renderer
        @posts_renderer ||= PostsRenderer.new
      end
    end
  end
end
