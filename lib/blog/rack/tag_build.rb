module Blog
  module Rack
    # Rack middleware to build tag pages on demand
    class TagBuild
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
        matched = env[::Rack::PATH_INFO].match(path)
        return app.call(env) if matched.nil? || matched[:tag].nil?

        build_page(tag: matched[:tag])
        app.call(env)
      end

      private

      def build_page(tag:)
        posts = post_repository
          .all_posts_sorted_by_time
          .filter { |post| post.tags.include?(tag) }
        html = tag_renderer.render(tag: tag, posts: posts)
        path = prepare_tag_path(tag: tag)
        path.open('wb') { |file| file.puts html }
      end

      def post_repository
        @post_repository ||= PostRepository.new(source: source)
      end

      def tag_renderer
        @tag_renderer ||= TagRenderer.new
      end

      def prepare_tag_path(tag:)
        dir = Blog.public_path.join(tag)
        dir.mkdir unless dir.exist?
        dir.join('index.html')
      end
    end
  end
end
