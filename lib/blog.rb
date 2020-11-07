require 'bundler/setup'

# Top-level namespace
module Blog
  autoload :CLI, 'blog/cli'
  autoload :PostRepository, 'blog/post_repository'
  autoload :Post, 'blog/post'
  autoload :PostsRenderer, 'blog/posts_renderer'
end
