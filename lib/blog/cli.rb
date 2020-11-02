require "blog/command/build"

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
      stop_with HELP_MESSAGE if help_needed?
      stop_with "command not found: #{@arguments.first}" if command.nil?
    end

    private

    # @param [String] message message printed when exit
    def stop_with(message)
      @error_output.puts message
      exit 1
    end

    # @return [Boolean] whether CLI is needed for help
    def help_needed?
      @arguments.include?("-h") || @arguments.include?("--help")
    end

    # @return [Command::Build, nil] command found by arguments
    def command
      case @arguments.first
      when "build"
        Command::Build.new
      else
        nil
      end
    end
  end
end
