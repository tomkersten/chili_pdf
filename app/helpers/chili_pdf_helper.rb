module ChiliPdfHelper
  # Taken almost verbatim from wicked_pdf gem
  def chili_pdf_stylesheets
    css_dir = Rails.root.join('public','plugin_assets', 'chili_pdf', 'stylesheets')
    css_file_list = Dir.glob("#{css_dir}/*css")
    css_file_list.collect { |css_file|
      "<style type='text/css'>#{File.read(css_file)}</style>"
    }.join("\n")
  end

  def update_img_src_tags_of(content, wants_html = false)
    return content if wants_html

    doc = ::Nokogiri::HTML(content)
    doc.xpath('//img').each do |img_tag|
      img_tag['src'] = TagMangler.new(img_tag['src']).to_local_src
    end
    doc.to_s
  end
end
