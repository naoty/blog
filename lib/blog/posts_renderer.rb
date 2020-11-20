require 'erb'

module Blog
  # Renderer for index page of posts
  class PostsRenderer
    def initialize
      template = Blog.root_path.join('template', 'index.html.erb')
      @erb = ERB.new(template.read, trim_mode: '-')
    end

    # Render HTML from posts
    # @param [Array<Post>] posts the list of posts
    # @return [String] rendered HTML
    def render(posts)
      @erb.result(binding)
    end
  end
end
