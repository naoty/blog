module Blog
  # the post of blog
  class Post
    attr_reader :id, :time, :title, :description, :tags, :og_image_url, :body

    # @param [Integer] id the ID of post
    # @param [String] title the title of post
    # @param [String] description the description of post
    # @param [Time] time the published time of post
    # @param [Array<String>] tags the tags of post
    # @param [String] og_image_url the url of image used for og:image
    # @param [String] body the body of post
    def initialize(id:, title:, description:, time:, tags:, og_image_url:, body:)
      @id = id
      @title = title
      @description = description
      @time = time
      @tags = tags
      @og_image_url = og_image_url
      @body = body
    end

    def inspect
      "#<Blog::Post @id=#{id}, @title=#{title}>"
    end
  end
end
