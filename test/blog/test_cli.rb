require "test_helper"
require "blog/cli"

module Blog
  class TestCLI < Minitest::Test
    def test_help_option
      output = StringIO.new
      cli = CLI.new(arguments: ["-h"], output: output)

      assert_raises(SystemExit) { cli.run }
      assert_equal <<~TEXT, output.string
        Usage:
          blog -h | --help

        Options:
          -h --help  Show this message
      TEXT
    end
  end
end
