module Blog
  # the post of blog
  class Post
    attr_reader :id, :time, :title, :tags, :body

    # @param [Integer] id the ID of post
    # @param [String] title the title of post
    # @param [Time] time the published time of post
    # @param [Array<String>] tags the tags of post
    # @param [String] body the body of post
    def initialize(id:, title:, time:, tags:, body:)
      @id = id
      @title = title
      @time = time
      @tags = tags
      @body = body
    end

    def inspect
      "#<Blog::Post @id=#{id}, @title=#{title}>"
    end
  end
end
