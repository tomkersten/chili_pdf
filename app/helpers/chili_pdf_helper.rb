module ChiliPdfHelper
  # Public directory of ChiliPDF plugin JavaScript files
  PLUGIN_JS_DIR = Rails.root.join('public','plugin_assets', 'chili_pdf', 'javascripts')

  # Public directory of ChiliPDF plugin stylesheets
  PLUGIN_CSS_DIR = Rails.root.join('public','plugin_assets', 'chili_pdf', 'stylesheets')

  # Standard <script>-tag for Prototype JavaScript file
  PROTOTYPE_SCRIPT_TAG = "#{Rails.root}/public/javascripts/prototype.js"


  # Public: Generates <link> tags for all CSS files in the
  #         plugin_assets/chili_pdf/stylesheets directory, formatting
  #         the 'href' attribute value appropriately for HTML or PDF
  #         request types.
  #
  # wants_html - specifies whether the 'src' attribute should be formatted
  #              for HTML or PDF requests (local vs. relative paths). Added to
  #              keep excessive boolean logic out of views.
  #
  # Returns: String of link tags separated by a newline character.
  def chili_pdf_stylesheets(wants_html)
    file_type_list(:css, PLUGIN_CSS_DIR, wants_html) {|asset_path|
      "<link href='#{asset_path}' rel='stylesheet' type='text/css' />\n"
    }.join("\n")
  end


  # Public: Generate JS <script> tags for all JavaScript files in the
  #         plugin_assets/chili_pdf/stylesheets directory, formatting
  #         the 'src' attribute value appropriately for HTML or PDF request
  #         types
  #
  # wants_html - specifies whether the 'src' attribute should be formatted
  #              for HTML or PDF requests (local vs. relative paths). Added to
  #              keep excessive boolean logic out of views.
  #
  # Returns: string of <script> tags separated by a newline character
  def chili_pdf_javascripts(wants_html)
    file_type_list(:js, PLUGIN_JS_DIR, wants_html) {|asset_path|
      "<script src='#{asset_path}' type='text/javascript'></script>"
    }.join("\n")
  end


  # Public: Converts 'href' attributes of any <link> tags
  #         tags to be compatible with the `wkhtmltopdf` executable
  #         requirements, using "file://"-format for all local assets.
  #
  # content    - the String of HTML content to normalize/update
  # wants_html - specifies whether the 'src' attribute should be formatted
  #              for HTML or PDF requests (local vs. relative paths). Added to
  #              keep excessive boolean logic out of views.
  #
  # Returns content un-modified if wants_html is true. Otherwise returns
  #         the content string with the modified 'href' attribute on all
  #         locally-hosted <link>-tags in content.
  def normalize_custom_link_href_tags_in(content, wants_html = false)
    update_tag_attribute(:link, :href, content, wants_html)
  end


  # Public: Converts 'src' attributes of any <script> tags (with a 'src'
  #         attribute) to be compatible with the `wkhtmltopdf` executable
  #         requirements, using "file://"-format for all local assets.
  #
  # content    - the String of HTML content to normalize/update
  # wants_html - specifies whether the 'src' attribute should be formatted
  #              for HTML or PDF requests (local vs. relative paths). Added to
  #              keep excessive boolean logic out of views.
  #
  # Returns content un-modified if wants_html is true. Otherwise returns
  #         the content string with the modified 'src' attribute on all
  #         locally-hosted <script>-tags in content.
  def normalize_custom_js_src_tags_in(content, wants_html = false)
    update_tag_attribute(:script, :src, content, wants_html)
  end


  # Public: Converts 'src' attributes of any <img> tags to be compatible with
  #         the `wkhtmltopdf` executable requirements, using "file://"-format
  #         for all local assets.
  #
  # content    - the String of HTML content to normalize/update
  # wants_html - specifies whether the 'src' attribute should be formatted
  #              for HTML or PDF requests (local vs. relative paths). Added to
  #              keep excessive boolean logic out of views.
  #
  # Returns content un-modified if wants_html is true. Otherwise returns
  #         the content string with the modified 'src' attribute on all
  #         locally-hosted <img>-tags in content.
  def update_img_src_tags_of(content, wants_html = false)
    update_tag_attribute(:img, :src, content, wants_html)
  end


  private
    # Updates the value of the specified attribute of any `tag_type` tags
    # contained in `content` to be compatible with the `wkhtmltopdf`
    # executable. If `wants_html` is falsey, no modifications are made
    # to content.
    #
    # tag_type   - String-link object which returns the tag to look for in
    #              'content' when #to_s is called on it.
    # content    - String of the HTML content to search for `tag_type' in
    # wants_html - specifies whether the attribute should be formatted
    #              for HTML or PDF requests (local vs. relative paths). Added to
    #              keep excessive boolean logic out of views.
    def update_tag_attribute(tag_type, attribute, content, wants_html)
      return content if wants_html

      doc = ::Nokogiri::HTML(content)
      doc.xpath("//#{tag_type.to_s}[@#{attribute.to_s}]").each do |a_tag|
        a_tag["#{attribute.to_s}"] = mangle(a_tag["#{attribute.to_s}"])
      end
      doc.to_s
    end


    # Generate list of content based on files with the specified file extension
    # in the specified source directory. The object passed into the block will
    # be the path to an individual file path in either HTML- or PDF-request
    # compatible form (file://-based or relative-url based). Useful for
    # generating a series of tags for all files matching a particular file type
    # in a specified directory.
    #
    # file_ext   - the file extension to search for in the src_dir
    # src_dir    - the directory to search for file with the specified
    #              file extension (file_ext)
    # wants_html - specifies whether the 'src' attribute should be formatted
    #              for HTML or PDF requests (local vs. relative paths). Added to
    #              keep excessive boolean logic out of views.
    # &block     - code to execute on each matching filename (filename is
    #              passed in as a parameter to &block)
    # Returns an Array of the results of the &block executions.
    def file_type_list(file_ext, src_dir, wants_html, &block)
      # We want/need to prepend the Prototype script-tag before all other script-tags
      file_list = file_ext.to_s == "js" ? [PROTOTYPE_SCRIPT_TAG] : []

      file_list.push(*Dir.glob("#{src_dir}/*#{file_ext.to_s}")).collect do |file_path|
        asset_path = file_path.to_s.sub(/^#{Rails.root}\/public/, '')
        asset_path = mangle(asset_path) unless wants_html
        yield asset_path
      end
    end

    # Converts the specified String to PDF-format-friendly version of itself.
    # Supports the '/attachments/:id/:filename' and '/attachments/download/:id' routes
    # of ChiliProject as well as standard static assets (nested under RAILS_ROOT/public).
    #
    # content - String to convert
    #
    # Examples
    #
    #   mangle('/stylesheets/application.css')
    #   => "file:///path/to/rails_root/public/stylesheets/application.css"
    #
    #   mangle('/attachments/1/image.png')
    #   => "file:///path/to/rails_root/files/38278327_image.png"
    #
    # Returns modified String, unless requested asset either doesn't exist
    #   or is an invalid request (to, say, an asset located above
    #   the 'RAILS_ROOT/public' sub-directory.
    def mangle(content)
      TagMangler.new(content).to_local_src
    end
end
