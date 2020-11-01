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

    def initialize
    end

    # Run +blog+ command with arguments
    #
    # @param [ARGV, Array<String>] arguments the arguments to +blog+ command.
    def run(arguments: ARGV)
      if arguments.include?("-h") || arguments.include?("--help")
        puts HELP_MESSAGE
        exit
      end

      raise NotImplementedError
    end
  end
end
