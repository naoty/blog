module Blog
  # Raised when PostRepository cannot find any Post.
  class PostNotFound < StandardError
    attr_reader :id

    def initialize(id:)
      @id = id
      super
    end
  end
end
