require 'bundler/setup'
require 'pathname'

# Top-level namespace
module Blog
  autoload :CLI, 'blog/cli'
  autoload :Command, 'blog/command'
  autoload :PostRenderer, 'blog/post_renderer'
  autoload :PostRepository, 'blog/post_repository'
  autoload :Post, 'blog/post'
  autoload :PostsRenderer, 'blog/posts_renderer'
  autoload :Rack, 'blog/rack'

  [
    :PostNotFound
  ].each { |klass| autoload klass, 'blog/errors' }

  # Return root path of this repository
  # @return [Pathname] the root path of this repository
  def self.root_path
    @root_path ||= Pathname.new(__dir__).parent
  end

  # Return public path
  # @return [Pathname] the path to public directory
  def self.public_path
    @public_path ||= Pathname.pwd.join('public')
  end
end
