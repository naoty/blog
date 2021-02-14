module Blog
  # This filter wraps image tags with <figure> and adds <figcaption> with
  # the title of images if an image tag has a title.
  class ImageCaptionFilter < ::HTML::Pipeline::Filter
    def call
      doc.search('img').each do |element|
        next if element['title'].nil? || element['title'].empty?

        content = element['title']
        element.remove_attribute('title')

        figure = doc.document.create_element('figure')
        figure.add_child(element.dup)

        figcaption = doc.document.create_element('figcaption', content)
        figure.add_child(figcaption)

        element.replace(figure)
      end

      doc
    end
  end
end
