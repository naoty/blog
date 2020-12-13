module Blog
  # A namespace for custom rack applications and middlewares
  module Rack
    autoload :NotFound, 'blog/rack/not_found'
    autoload :PostBuild, 'blog/rack/post_build'
    autoload :PostsBuild, 'blog/rack/posts_build'
    autoload :PrettyURLs, 'blog/rack/pretty_urls'
    autoload :TagBuild, 'blog/rack/tag_build'
  end
end
