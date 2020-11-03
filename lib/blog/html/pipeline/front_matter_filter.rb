require 'html/pipeline'
require 'yaml'

module Blog
  module HTML
    module Pipeline
      # Custom Filter to convert front matter to metadata
      class FrontMatterFilter < ::HTML::Pipeline::Filter
        def call
          parts = doc.content.split("---\n", 3)
          return doc.to_html if parts.length < 3

          result[:front_matter] = parse_front_matter(parts[1])
          parts[2]
        end

        private

        def parse_front_matter(text)
          result = YAML.safe_load(text).transform_keys(&:to_sym)

          case result
          when Hash
            result
          end
        end
      end
    end
  end
end
