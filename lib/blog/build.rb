require 'fileutils'
require 'pathname'

module Blog
  # +blog build+ command
  class Build < Command
    # Run +blog build+ command
    def run
      posts = post_repository.all_posts_sorted_by_time
      build_posts_page(posts)
      build_post_pages(posts)
      copy_post_assets
      copy_static_files
    end

    private

    def build_posts_page(posts)
      html = posts_renderer.render(posts)
      Blog.public_path.join('index.html').open('wb') { |file| file.puts html }
    end

    def build_post_pages(posts)
      posts.each { |post| build_post_page(post) }
    end

    def build_post_page(post)
      html = post_renderer.render(post)
      post_path = Blog.public_path.join(post.id.to_s)
      post_path.mkdir unless post_path.exist?
      post_path.join('index.html').open('wb') { |file| file.puts html }
    end

    def post_repository
      @post_repository ||= PostRepository.new(source: source)
    end

    def posts_renderer
      @posts_renderer ||= PostsRenderer.new
    end

    def post_renderer
      @post_renderer ||= PostRenderer.new
    end
  end
end
