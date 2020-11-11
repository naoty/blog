module Blog
  # A namespace for custom rack applications and middlewares
  module Rack
    autoload :NotFound, 'blog/rack/not_found'
    autoload :PrettyURLs, 'blog/rack/pretty_urls'
  end
end
