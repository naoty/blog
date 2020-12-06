module Blog
  class Command
    attr_reader :source

    # @param [Pathname] source the directory Post data are persisted
    def initialize(source:)
      @source = source
    end

    def run
      raise NotImplementedError
    end

    private

    # @param [Pathname] public_path public path where static files are copied
    def copy_static_files
      FileUtils.cp_r(Blog.root_path.join('static/.'), Blog.public_path)
    end
  end
end
