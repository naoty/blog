require 'fileutils'

module Blog
  class Command
    private attr_reader :source, :output

    # @param [Pathname] source The directory Post data are persisted
    # @param [IO] output Output stream for messages
    def initialize(source:, output:)
      @source = source
      @output = output
    end

    def run
      raise NotImplementedError
    end

    private

    # @param [Pathname] public_path public path where static files are copied
    def copy_static_files
      FileUtils.cp_r(Blog.root_path.join('static/.'), Blog.public_path)
    end

    def copy_post_assets
      source
        .glob('*/*')
        .select { |path| path.parent.basename.to_s.match?(/\d+/) }
        .reject(&:directory?)
        .reject { |path| path.basename.to_s == 'post.md' }
        .each { |path| copy_post_asset(path: path) }
    end

    def copy_post_asset(path:)
      relative_path = path.relative_path_from(source)
      target_path = Blog.public_path.join(relative_path)
      target_path.parent.mkpath
      FileUtils.cp(path, target_path)
    end
  end
end
