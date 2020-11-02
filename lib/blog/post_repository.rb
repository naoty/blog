module Blog
  # An object that decodes Posts from file system.
  class PostRepository
    # @param [Pathname] source the directory Post data are persisted
    def initialize(source:)
      @source = source
    end
  end
end
