require 'test_helper'

module Blog
  class TestServe < Minitest::Test
    attr_reader :tmpdir, :source

    def setup
      @tmpdir = Pathname.new(Dir.mktmpdir)
      @source = Pathname.new(Dir.mktmpdir)
    end

    def teardown
      tmpdir.rmtree
      source.rmtree
    end

    def test_run
      Dir.chdir tmpdir do
        command = Serve.new(source: source, output: File.new(File::NULL))
        command.stub :start_server, nil do
          command.run
        end

        public_path = tmpdir.join('public')
        assert public_path.exist?

        not_found_path = public_path.join('404.html')
        assert not_found_path.exist?
      end
    end
  end
end
