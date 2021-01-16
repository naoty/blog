require 'html/pipeline'
require 'time'
require 'yaml'

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
          ::HTML::Pipeline::MarkdownFilter,
          ::HTML::Pipeline::SyntaxHighlightFilter,
        ]
      )
    end

    # @param [Pathname] path path to post file includeing text representation
    # @return [Post, nil] a Post decoded from text
    def post_from(path)
      text, front_matter = split_front_matter(path.read)
      result = pipeline.call(text)
      time = time_from(front_matter)
      id = path.dirname.basename.to_s.to_i

      Post.new(
        id: id,
        title: front_matter[:title],
        time: time,
        tags: front_matter[:tags] || [],
        body: result[:output]
      )
    end

    def split_front_matter(text)
      parts = text.split("---\n", 3)
      front_matter = YAML
        .safe_load(parts[1], permitted_classes: [Time])
        .transform_keys(&:to_sym)
      [parts[2], front_matter]
    end

    # @param [Hash] front_matter The front matter of post
    # @return [Time, nil] Time object fetched from post file
    def time_from(front_matter)
      time_in_front_matter = front_matter[:time]
      case time_in_front_matter
      when Time
        time_in_front_matter
      when String
        Time.parse(time_in_front_matter)
      end
    end
  end
end
