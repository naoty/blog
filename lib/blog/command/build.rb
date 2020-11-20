require 'fileutils'
require 'pathname'

module Blog
  module Command
    # +blog build+ command
    class Build
      attr_reader :source

      # @param [Pathname] source the directory Post data are persisted
      def initialize(source:)
        @source = source
      end

      # Run +blog build+ command
      def run
        public_path = ensure_public_path
        copy_static_files(public_path: public_path)

        posts = post_repository.all_posts_sorted_by_time
        html = posts_renderer.render(posts)
        public_path.join('index.html').open('wb') { |file| file.puts html }
      end

      private

      def post_repository
        @post_repository ||= PostRepository.new(source: source)
      end

      def posts_renderer
        @posts_renderer ||= PostsRenderer.new
      end

      # @return [Pathname] public path that built files are output
      def ensure_public_path
        public_path = Pathname.pwd.join('public')
        public_path.mkdir unless public_path.exist?
        public_path
      end

      # @param [Pathname] public_path public path where static files are copied
      def copy_static_files(public_path:)
        FileUtils.cp_r(Blog.root_path.join('static/.'), public_path)
      end
    end
  end
end
