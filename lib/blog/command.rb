module Blog
  module Command
    autoload :Build, 'blog/command/build'
    autoload :Serve, 'blog/command/serve'
  end
end
