require 'pathname'

module Blog
  module Command
    # +blog build+ command
    class Build
      # @param [Pathname] source the directory Post data are persisted
      def initialize(source:)
        @post_repository = PostRepository.new(source: source)
        @posts_renderer = PostsRenderer.new
      end

      # Run +blog build+ command
      def run
        posts = @post_repository.all_posts_sorted_by_time
        html = @posts_renderer.render(posts)
        public_path = ensure_public_path
        public_path.join('index.html').open('wb') { |file| file.puts html }
      end

      private

      # @return [Pathname] public path that built files are output
      def ensure_public_path
        public_path = Pathname.pwd.join('public')
        public_path.mkdir unless public_path.exist?
        public_path
      end
    end
  end
end
