module ChiliPdfHelper
  # Loads all CSS files in the plugin_assets/chili_pdf/stylesheets
  # directory
  def chili_pdf_stylesheets(wants_html)
    normalize_css_src_tags_in(chili_pdf_css_link_tags, wants_html)
  end

  def chili_pdf_javascripts(wants_html)
    normalize_js_src_tags_in(chili_pdf_script_tags, wants_html)
  end



  def normalize_css_src_tags_in(content, wants_html = false)
    return content if wants_html

    doc = ::Nokogiri::HTML(content)
    doc.xpath('//link[@href]').each do |link_tag|
      link_tag['href'] = TagMangler.new(link_tag['href']).to_local_src
    end
    doc.to_s
  end


  def normalize_js_src_tags_in(content, wants_html = false)
    return content if wants_html

    doc = ::Nokogiri::HTML(content)
    doc.xpath('//script[@src]').each do |script_tag|
      script_tag['src'] = TagMangler.new(script_tag['src']).to_local_src
    end
    doc.to_s
  end

  def update_img_src_tags_of(content, wants_html = false)
    return content if wants_html

    doc = ::Nokogiri::HTML(content)
    doc.xpath('//img').each do |img_tag|
      img_tag['src'] = TagMangler.new(img_tag['src']).to_local_src
    end
    doc.to_s
  end


  private
    def chili_pdf_css_link_tags
      tag_list(:css, plugin_css_dir) {|filename|
        "<link href='/plugin_assets/chili_pdf/stylesheets/#{filename}' rel='stylesheet' type='text/css' />\n"
      }.join("\n")
    end

    def chili_pdf_script_tags
      prototype_script_tag +
      tag_list(:js, plugin_js_dir) {|filename|
        "<script src='/plugin_assets/chili_pdf/javascripts/#{filename}' type='text/javascript'></script>"
      }.join("\n")
    end

    def tag_list(file_ext, src_dir)
      Dir.glob("#{src_dir}/*#{file_ext.to_s}").collect do |file_path|
        yield file_path.split("/").last
      end
    end

    def plugin_js_dir
      Rails.root.join('public','plugin_assets', 'chili_pdf', 'javascripts')
    end

    def plugin_css_dir
      Rails.root.join('public','plugin_assets', 'chili_pdf', 'stylesheets')
    end

    def prototype_script_tag
      "<script src='/javascripts/prototype.js' type='text/javascript'></script>\n"
    end
end
