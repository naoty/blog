require 'test_helper'
require 'blog/cli'

module Blog
  class TestCLI < Minitest::Test
    def test_help_option
      error_output = StringIO.new
      cli = CLI.new(arguments: ['-h'], error_output: error_output)

      assert_raises(SystemExit) { cli.run }
      assert_equal <<~TEXT, error_output.string
        Usage:
          blog build <source>
          blog serve <source>
          blog -h | --help

        Options:
          -h --help  Show this message
      TEXT
    end

    def test_run_build_command
      mock = Minitest::Mock.new
      mock.expect(:run, nil)
      mock.expect(:nil?, false)

      Command::Build.stub(:new, mock) do
        CLI.new(arguments: %w[build source]).run
      end

      assert mock.verify
    end

    def test_run_serve_command
      mock = Minitest::Mock.new
      mock.expect(:run, nil)
      mock.expect(:nil?, false)

      Command::Serve.stub(:new, mock) do
        CLI.new(arguments: %w[serve source]).run
      end

      assert mock.verify
    end

    def test_source_not_found
      error_output = StringIO.new
      cli = CLI.new(arguments: ['build'], error_output: error_output)

      assert_raises(SystemExit) { cli.run }
      assert_equal "usage: blog (build | serve) <source>\n", error_output.string
    end

    def test_command_not_found
      error_output = StringIO.new
      cli = CLI.new(arguments: %w[foo source], error_output: error_output)

      assert_raises(SystemExit) { cli.run }
      assert error_output.string.start_with?('command not found:')
    end
  end
end
