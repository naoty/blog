module Blog
  # A namespace for classes implementing commands
  module Command
    autoload :Build, 'blog/command/build'
    autoload :Serve, 'blog/command/serve'
  end
end
