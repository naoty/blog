require 'pathname'

module Blog
  # Blog CLI
  class CLI
    HELP_MESSAGE = <<~TEXT.freeze
      Usage:
        blog build <source>
        blog serve <source>
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
      stop_with 'usage: blog (build | serve) <source>' if source.nil?
      stop_with "command not found: #{@arguments.first}" if command.nil?

      command.run
    end

    private

    # @param [String] message message printed when exit
    def stop_with(message)
      @error_output.puts message
      exit 1
    end

    # @return [Boolean] whether CLI is needed for help
    def help_needed?
      @arguments.include?('-h') || @arguments.include?('--help')
    end

    # @return [Pathname] path to the directory Post data are persisted
    def source
      @source ||= @arguments.length >= 2 ? Pathname.pwd.join(@arguments[1]) : nil
    end

    # @return [Command::Build, nil] command found by arguments
    def command
      @command ||= case @arguments.first
                   when 'build'
                     Command::Build.new(source: source)
                   when 'serve'
                     Command::Serve.new(source: source)
                   end
    end
  end
end
