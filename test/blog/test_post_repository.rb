require 'test_helper'

module Blog
  class TestPostRepository < Minitest::Test
    attr_reader :source, :repository

    def setup
      @source = Pathname.new(Dir.mktmpdir)
      @repository = PostRepository.new(source: source)
    end

    def teardown
      source.rmtree
    end

    def test_find_nothing
      assert_raises(PostNotFound) { repository.find(1) }
    end

    def test_find_post
      setup_source(post_number: 1)
      post = Post.new(id: 1, title: '', time: Time.new(2020, 1, 1), tags: [], body: '')
      repository.stub(:post_from, post) { repository.find(1) }
    end

    def test_all_posts_sorted_by_time
      setup_source(post_number: 2)

      posts = [
        Post.new(id: 1, title: '', time: Time.new(2020, 1, 1), tags: [], body: ''),
        Post.new(id: 2, title: '', time: Time.new(2020, 1, 2), tags: [], body: '')
      ]

      repository.stub(:post_from, proc { posts.shift }) do
        posts = repository.all_posts_sorted_by_time

        assert_equal 2, posts.length
        assert_equal [2, 1], posts.map(&:id)
      end
    end

    def test_post_from
      post_directory = setup_post_directory
      post_path = post_directory.join('post.md')
      post = repository.send(:post_from, post_path)

      assert_equal 1, post.id
      assert_equal 'dummy', post.title
      assert_equal Time.new(2020, 1, 1, 0, 0), post.time
      assert_equal ['ruby'], post.tags
    end

    def test_time_from_string
      result = { front_matter: { time: '2020-01-01 0:00' } }
      time = repository.send(:time_from, result)

      assert_equal Time.new(2020, 1, 1, 0, 0), time
    end

    def test_time_from_time
      result = { front_matter: { time: Time.new(2020, 1, 1, 0, 0) } }
      time = repository.send(:time_from, result)

      assert_equal Time.new(2020, 1, 1, 0, 0), time
    end

    # @param [Integer] post_number the number of posts
    def setup_source(post_number: 1)
      post_number.times do |n|
        id = n + 1
        post_directory = source.join(id.to_s)
        post_directory.mkdir

        post_directory.join('post.md').open('wb') do |file|
          file.puts(dummy_post_content(id: id))
        end
      end
    end

    def setup_post_directory
      post_directory = source.join('1')
      post_directory.mkdir

      post_path = post_directory.join('post.md')
      post_path.open('wb') { |file| file.puts dummy_post_content }

      post_directory
    end

    # @param [Integer] id the ID of dummy post
    def dummy_post_content(id: 1)
      time = Time.new(2020, 1, 1) + (id - 1) * 24 * 60 * 60
      <<~TEXT
        ---
        title: dummy
        time: #{time.strftime('%Y-%m-%d %H:%M')}
        tags: ['ruby']
        ---

        # header
        here is paragraph.
      TEXT
    end
  end
end
