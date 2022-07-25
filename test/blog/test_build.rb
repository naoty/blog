require 'test_helper'
require 'nokogiri'
require 'fileutils'

module Blog
  class TestBuild < Minitest::Test
    POST_NUMBER = 2
    TAG = 'ruby'

    attr_reader :tmpdir, :command

    def setup
      @tmpdir = Pathname.new(Dir.mktmpdir)
      source = setup_source(root: @tmpdir)
      @command = Build.new(source: source, output: StringIO.new)
    end

    def teardown
      tmpdir.rmtree
    end

    def test_run
      Dir.chdir tmpdir do
        command.run
        assert_building_posts_page
        1.upto(POST_NUMBER) { |id| assert_building_post_page(id: id) }
        assert_building_tag_page(tag: TAG)
        assert_building_feed
      end
    end

    private

    # @param [Pathname] root the root path which includes source path
    # @return [Pathname] source path
    def setup_source(root:)
      source = root.join('source')
      source.mkdir
      1.upto(POST_NUMBER) { |id| setup_post_dir(source: source, id: id) }
      source
    end

    # @param [Pathname] source the source path which includes post directories
    # @param [Integer] id the ID of post
    def setup_post_dir(source:, id:)
      post_dir = source.join(id.to_s)
      post_dir.mkdir

      post_path = post_dir.join('post.md')
      post_path.open('wb') do |file|
        file.puts dummy_post_content(id: id)
      end

      asset_path = Blog.root_path.join('test', 'asset', 'image.png')
      FileUtils.cp(asset_path, post_dir.join('image.png'))
    end

    # @param [Integer] id the ID of post
    def dummy_post_content(id:)
      time = Time.new(2020, 1, 1) + ((id - 1) * 24 * 60 * 60)
      <<~TEXT
        ---
        title: dummy #{id}
        time: #{time.strftime('%Y-%m-%d %H:%M')}
        tags: ['#{TAG}']
        ---

        # header
        Here is paragraph.
      TEXT
    end

    def assert_building_posts_page
      assert public_path.exist?
      assert index_path.exist?
      assert static_file_path.exist?

      document = Nokogiri::HTML(index_path.read)

      # POST_NUMBER + link to home
      assert_equal POST_NUMBER + 1, document.search('li').length
    end

    def assert_building_post_page(id:)
      assert post_dir(id: id).exist?
      assert post_path(id: id).exist?
      assert post_asset_path(id: id).exist?
    end

    def assert_building_tag_page(tag:)
      assert tag_dir(tag: tag).exist?
      assert tag_path(tag: tag).exist?
    end

    def assert_building_feed
      assert public_path.join('feed.xml').exist?
    end

    def public_path
      @public_path ||= tmpdir.join('public')
    end

    def index_path
      @index_path ||= public_path.join('index.html')
    end

    def static_file_path
      @static_file_path ||= public_path.join('404.html')
    end

    def post_dir(id:)
      public_path.join(id.to_s)
    end

    def post_path(id:)
      post_dir(id: id).join('index.html')
    end

    def post_asset_path(id:)
      post_dir(id: id).join('image.png')
    end

    def tag_dir(tag:)
      public_path.join(tag)
    end

    def tag_path(tag:)
      tag_dir(tag: tag).join('index.html')
    end
  end
end
