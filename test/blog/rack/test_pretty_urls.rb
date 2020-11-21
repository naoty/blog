require 'test_helper'

module Blog
  module Rack
    class TestPrettyURLs < Minitest::Test
      attr_reader :app

      def setup
        @app = PrettyURLs.new(->(env) { [200, env, '200 OK'] })
      end

      def test_call_with_trailing_slash
        request = ::Rack::MockRequest.env_for('/')
        _, env, = app.call(request)
        assert_equal env[::Rack::PATH_INFO], '/index.html'
      end

      def test_call_without_trailing_slash
        request = ::Rack::MockRequest.env_for('/test')
        _, env, = app.call(request)
        assert_equal env[::Rack::PATH_INFO], '/test'
      end
    end
  end
end
