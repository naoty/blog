module Blog
  # Blog CLI
  class CLI
    HELP_MESSAGE = <<~TEXT.freeze
      Usage:
        blog -h | --help

      Options:
        -h --help  Show this message
    TEXT
    private_constant :HELP_MESSAGE

    # @param [ARGV, Array<String>] arguments the arguments to +blog+ command.
    # @param [IO] output output stream for messages
    # @param [IO] error_output output stream for error messages
    def initialize(arguments: ARGV, output: $stdout, error_output: $stderr)
      @arguments = arguments
      @output = output
      @error_output = error_output
    end

    # Run +blog+ command with arguments
    def run
      if help_needed?
        @output.puts HELP_MESSAGE
        exit
      end

      raise NotImplementedError
    end

    private

    def help_needed?
      @arguments.include?("-h") || @arguments.include?("--help")
    end
  end
end
