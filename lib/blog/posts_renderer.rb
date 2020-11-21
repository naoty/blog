module Blog
  # Renderer for index page of posts
  class PostsRenderer
    # Render HTML from posts
    # @param [Array<Post>] posts the list of posts
    # @return [String] rendered HTML
    def render(posts)
      erb.result(binding)
    end

    private

    def erb
      @erb ||= ERB.new(template.read, trim_mode: '-')
    end

    def template
      @template ||= Blog.root_path.join('template', 'index.html.erb')
    end
  end
end
