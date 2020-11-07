module Blog
  module Rack
    # Rack application to serve blog
    class Application
      # @param [PostRepository] post_repository the repository of Posts
      def initialize(post_repository:)
        @post_repository = post_repository
        @posts_renderer = PostsRenderer.new
      end

      def call(_env)
        posts = @post_repository.all_posts_sorted_by_time
        html = @posts_renderer.render(posts)

        [
          200,
          {
            'Content-Type' => 'text/html',
            'Content-Length' => html.length
          },
          [html]
        ]
      end
    end
  end
end
