require 'rack'

module Blog
  # +blog serve+ command
  class Serve < Command
    def run
      copy_static_files
      start_server
    end

    private

    def start_server
      ::Rack::Handler::WEBrick.run(rack_app)
    end

    def rack_app
      @rack_app ||= begin
        source = @source

        ::Rack::Builder.new do
          use Rack::NotFound
          use Rack::PostsBuild, path: '/', source: source
          use Rack::PostBuild, path: %r{/(?<id>\d+)/}, source: source
          use Rack::PrettyURLs
          run ::Rack::Files.new(Blog.public_path)
        end
      end
    end
  end
end
