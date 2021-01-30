require 'test_helper'
require 'nokogiri'

module Blog
  class TestPostsRenderer < Minitest::Test
    attr_reader :renderer

    def setup
      @renderer = PostsRenderer.new
    end

    def test_render
      posts = [
        Post.new(id: 1, title: 'dummy', description: nil, time: Time.new(2020, 1, 1), tags: [], og_image_url: nil, body: ''),
        Post.new(id: 2, title: 'dummy', description: nil, time: Time.new(2020, 1, 2), tags: [], og_image_url: nil, body: '')
      ]
      html = renderer.render(posts)
      document = Nokogiri::HTML(html)

      # links to posts and link to home
      assert_equal 3, document.search('li').length
    end
  end
end
