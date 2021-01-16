require 'blog/html/pipeline/front_matter_filter'
require 'html/pipeline'
require 'time'

module Blog
  # An object that decodes Posts from file system.
  class PostRepository
    attr_reader :source

    # @param [Pathname] source the directory Post data are persisted
    def initialize(source:)
      @source = source
    end

    # Get a Post with passed ID.
    # @param [Integer, String] id The ID of a Post
    # @raise [PostNotFound] raised when a Post with passed ID is not found
    # @return [Post] a Post with passed ID
    def find(id)
      post_dir = source.children.find { |child| child.basename.to_s == id.to_s }
      raise PostNotFound.new(id: id) if post_dir.nil?

      path = post_dir.join('post.md')
      post_from(path)
    end

    # Get all posts from source and sort them by time attribute
    def all_posts_sorted_by_time
      source
        .children
        .map { |child| child.join('post.md') }
        .filter(&:exist?)
        .map { |path| post_from(path) }
        .sort_by(&:time)
        .reverse
    end

    private

    def pipeline
      @pipeline ||= ::HTML::Pipeline.new(
        [
          Blog::HTML::Pipeline::FrontMatterFilter,
          ::HTML::Pipeline::MarkdownFilter,
          ::HTML::Pipeline::SyntaxHighlightFilter,
        ]
      )
    end

    # @param [Pathname] path path to post file includeing text representation
    # @return [Post, nil] a Post decoded from text
    def post_from(path)
      result = pipeline.call(path.read)
      time = time_from(result)
      id = path.dirname.basename.to_s.to_i

      Post.new(
        id: id,
        title: result.dig(:front_matter, :title),
        time: time,
        tags: result.dig(:front_matter, :tags) || [],
        body: result[:output]
      )
    end

    # @param [Hash] pipeline_result The result of Pipeline#call
    # @return [Time, nil] Time object fetched from post file
    def time_from(pipeline_result)
      time_in_result = pipeline_result.dig(:front_matter, :time)
      case time_in_result
      when Time
        time_in_result
      when String
        Time.parse(time_in_result)
      end
    end
  end
end
