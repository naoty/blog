module Blog
  module Command
    # +blog build+ command
    class Build
      # @param [Pathname] source the directory Post data are persisted
      def initialize(source:)
        @post_repository = PostRepository.new(source: source)
      end

      # Run +blog build+ command
      def run; end
    end
  end
end
