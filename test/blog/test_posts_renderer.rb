require 'test_helper'
require 'nokogiri'

module Blog
  class TestPostsRenderer < Minitest::Test
    def setup
      @renderer = PostsRenderer.new
    end

    def test_render
      posts = [
        Post.new(id: 1, title: 'dummy', time: Time.new(2020, 1, 1), tags: [], body: ''),
        Post.new(id: 2, title: 'dummy', time: Time.new(2020, 1, 2), tags: [], body: '')
      ]
      html = @renderer.render(posts)
      document = Nokogiri::HTML(html)

      assert_equal 2, document.search('li').length
    end
  end
end
