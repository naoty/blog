require "test_helper"
require "blog/cli"

module Blog
  class TestCLI < Minitest::Test
    def test_help_option
      error_output = StringIO.new
      cli = CLI.new(arguments: ["-h"], error_output: error_output)

      assert_raises(SystemExit) { cli.run }
      assert_equal <<~TEXT, error_output.string
        Usage:
          blog -h | --help

        Options:
          -h --help  Show this message
      TEXT
    end
  end
end
