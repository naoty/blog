require 'bundler/setup'
require 'erb'
require 'pathname'

# Top-level namespace
module Blog
  autoload :Build, 'blog/build'
  autoload :CLI, 'blog/cli'
  autoload :Command, 'blog/command'
  autoload :PostRenderer, 'blog/post_renderer'
  autoload :PostRepository, 'blog/post_repository'
  autoload :Post, 'blog/post'
  autoload :PostsRenderer, 'blog/posts_renderer'
  autoload :Rack, 'blog/rack'
  autoload :Serve, 'blog/serve'

  [
    :PostNotFound
  ].each { |klass| autoload klass, 'blog/errors' }

  # Return root path of this repository
  # @return [Pathname] the root path of this repository
  def self.root_path
    @root_path ||= Pathname.new(__dir__).parent
  end

  # Prepare and return public path
  # @return [Pathname] the path to public directory
  def self.public_path
    path = Pathname.pwd.join('public')
    path.mkdir unless path.exist?
    path
  end
end
