require 'rack'
require 'rackup'

module Blog
  # +blog serve+ command
  class Serve < Command
    def run
      link_static_files
      copy_post_assets
      trap(:INT, method(:handle_sigint))
      start_server
    end

    private

    def link_static_files
      Blog.root_path.join('static')
        .glob('**/*')
        .each { |path| link_static_file(path: path) }
    end

    def link_static_file(path:)
      static_path = Blog.root_path.join('static')
      relative_path = path.relative_path_from(static_path)
      target_path = Blog.public_path.join(relative_path)
      target_path.delete if target_path.exist?
      FileUtils.ln_s(path, target_path)
    end

    def start_server
      ::Rackup::Handler::WEBrick.run(rack_app)
    end

    def handle_sigint(_arg)
      ::Rackup::Handler::WEBrick.shutdown
    end

    def rack_app
      @rack_app ||= begin
        source = @source

        ::Rack::Builder.new do
          use Rack::NotFound, source: Blog.public_path
          use Rack::PostsBuild, path: '/', source: source
          use Rack::TagBuild, path: %r{/(?<tag>\S+)/}, source: source
          use Rack::PostBuild, path: %r{/(?<id>\d+)/}, source: source
          use Rack::PrettyURLs
          run ::Rack::Files.new(Blog.public_path)
        end
      end
    end
  end
end
