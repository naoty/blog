module Blog
  # Renderer for index page of tagged posts
  class TagRenderer
    # Render HTML from posts
    # @param [String] tag the tag of posts
    # @param [Array<Post>] posts the list of posts
    # @return [String] rendered HTML
    def render(tag:, posts:)
      erb.result(binding)
    end

    private

    def erb
      @erb ||= ERB.new(template.read, trim_mode: '-')
    end

    def template
      @template ||= Blog.root_path.join('template', ':tag', 'index.html.erb')
    end
  end
end
