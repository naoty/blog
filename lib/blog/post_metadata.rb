module Blog
  class PostMetadata
    attr_reader :id, :updated_at

    def initialize(id:, updated_at:)
      @id = id
      @updated_at = updated_at
    end

    def inspect
      "#<Blog::PostMetadata @id=#{id}>"
    end
  end
end
