module Blog
  module Rack
    # Rack middleware to build each post pages on request.
    class PostBuild
      attr_reader :app, :path, :source

      # @param [Object] app Rack application to be wrapped
      # @param [String, Regexp] path Pattern of the path of URL this middleware handles requests
      # @param [Pathname] source The path to source directory
      def initialize(app, path:, source:)
        @app = app
        @path = path
        @source = source
      end

      def call(env)
        matched = env[::Rack::PATH_INFO].match(path)
        return app.call(env) if matched.nil? || matched[:id].nil?

        build_post(id: matched[:id])
        app.call(env)
      rescue PostNotFound => e
        [404, env, e.message]
      end

      private

      def build_post(id:)
        post = post_repository.find(id)
        html = post_renderer.render(post)
        path = prepare_post_path(id: id)
        path.open('wb') { |file| file.puts html }
      end

      def post_repository
        @post_repository ||= PostRepository.new(source: source)
      end

      def post_renderer
        @post_renderer ||= PostRenderer.new
      end

      def prepare_post_path(id:)
        dir = Blog.public_path.join(id)
        dir.mkdir unless dir.exist?
        dir.join('index.html')
      end
    end
  end
end
