require 'rss'

module Blog
  # +blog build+ command
  class Build < Command
    # Run +blog build+ command
    def run
      posts = post_repository.all_posts_sorted_by_time
      build_posts_page(posts)
      build_post_pages(posts)
      build_tag_pages(posts)
      build_feed(posts)

      copy_post_assets
      copy_static_files
    end

    private

    def build_posts_page(posts)
      html = posts_renderer.render(posts)
      path = Blog.public_path.join('index.html')
      path.open('wb') { |file| file.puts html }
      output.puts "build: #{path}"
    end

    def build_post_pages(posts)
      posts.each { |post| build_post_page(post) }
    end

    def build_post_page(post)
      html = post_renderer.render(post)
      post_path = Blog.public_path.join(post.id.to_s)
      post_path.mkdir unless post_path.exist?

      path = post_path.join('index.html')
      path.open('wb') { |file| file.puts html }
      output.puts "build: #{path}"
    end

    def build_tag_pages(posts)
      posts_by_tag = {}
      posts.each do |post|
        post.tags.each do |tag|
          posts_by_tag[tag] ||= []
          posts_by_tag[tag] << post
        end
      end

      posts_by_tag.each do |tag, tagged_posts|
        build_tag_page(tag: tag, tagged_posts: tagged_posts)
      end
    end

    def build_tag_page(tag:, tagged_posts:)
      html = tag_renderer.render(tag: tag, posts: tagged_posts)
      tag_path = Blog.public_path.join(tag)
      tag_path.mkdir unless tag_path.exist?

      path = tag_path.join('index.html')
      path.open('wb') { |file| file.puts html }
      output.puts "build: #{path}"
    end

    def build_feed(posts)
      feed = generate_feed(posts)
      path = Blog.public_path.join('feed.xml')
      path.open('wb') { |file| file.puts feed }
      output.puts "build: #{path}"
    end

    def generate_feed(posts)
      feed = RSS::Maker.make('atom') do |maker|
        maker.channel.id = 'https://blog.naoty.dev/'
        maker.channel.title = 'blog.naoty.dev'
        maker.channel.link = 'https://blog.naoty.dev'
        maker.channel.author = 'Naoto Kaneko'
        maker.channel.updated = Time.new(2021, 1, 9) # when blog.naoty.dev is launched

        maker.items.do_sort = true
        posts.each do |post|
          maker.items.new_item do |item|
            item.id = "https://blog.naoty.dev/#{post.id}/"
            item.link = "https://blog.naoty.dev/#{post.id}/"
            item.title = post.title
            item.updated = post.time
            item.summary = post.body
          end
        end

        maker.image.url = 'https://blog.naoty.dev/icon.png'
      end
      feed.to_s
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

    def tag_renderer
      @tag_renderer ||= TagRenderer.new
    end
  end
end
