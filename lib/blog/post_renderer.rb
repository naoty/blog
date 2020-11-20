module Blog
  # Renderer for each post pages
  class PostRenderer
    # Render HTML from post
    # @param [Post] post a Post to be rendered
    # @return [String] rendered HTML
    def render(post)
      erb.result(binding)
    end

    private

    def erb
      @erb ||= ERB.new(template.read, trim_mode: '-')
    end

    def template
      @template ||= Blog.root_path.join('template', ':id', 'index.html.erb')
    end
  end
end
