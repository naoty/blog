require 'bundler/setup'
require 'pathname'

# Top-level namespace
module Blog
  autoload :CLI, 'blog/cli'
  autoload :Command, 'blog/command'
  autoload :PostRepository, 'blog/post_repository'
  autoload :Post, 'blog/post'
  autoload :PostsRenderer, 'blog/posts_renderer'

  # Return root path of this repository
  # @return [Pathname] the root path of this repository
  def self.root_path
    @root_path ||= Pathname.new(__dir__).parent
  end
end
