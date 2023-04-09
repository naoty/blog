require 'test_helper'

module Blog
  module Rack
    class TestPostBuild < Minitest::Test
      private attr_reader :app, :request, :tmpdir, :repository

      def setup
        @app = PostBuild.new(
          ->(env) { [200, env, '200 OK'] },
          path: %r{/(?<id>\d+)/},
          source: nil
        )
        @request = ::Rack::MockRequest.env_for('/1/')
        @tmpdir = Pathname.new(Dir.mktmpdir)

        post = Post.new(
          id: 1,
          title: 'title',
          description: 'description',
          time: Time.now,
          tags: ['tag'],
          og_image_url: nil,
          body: ''
        )
        @repository = Minitest::Mock.new.expect(:find, post, ['1'])
      end

      def teardown
        tmpdir.rmtree
      end

      def test_call
        Dir.chdir(tmpdir) do
          app.stub(:post_repository, repository) do
            app.call(request)
            post_path = Pathname.pwd.join('public', '1', 'index.html')
            assert post_path.exist?

            html = post_path.read
            assert html.include?('<html lang="ja">')
            assert html.include?('<script src="/reload.js"></script>')
          end
        end
      end
    end
  end
end
