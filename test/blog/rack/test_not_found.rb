require 'test_helper'

module Blog
  module Rack
    class TestNotFound < Minitest::Test
      attr_reader :request

      def setup
        @request = ::Rack::MockRequest.env_for('/')
      end

      def test_call_with_200_response
        app = NotFound.new(->(env) { [200, env, '200 OK'] })
        status, _, _ = app.call(request)
        assert_equal status, 200
      end

      def test_call_with_404_response
        app = NotFound.new(->(env) { [404, env, '404 Not Found'] })
        status, _, body = app.call(request)
        assert_equal status, 404
        assert body != '404 Not Found'
      end
    end
  end
end
