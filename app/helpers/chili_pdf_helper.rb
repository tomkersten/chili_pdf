module ChiliPdfHelper
  # Public directory of ChiliPDF plugin JavaScript files
  PLUGIN_JS_DIR = Rails.root.join('public','plugin_assets', 'chili_pdf', 'javascripts')

  # Public directory of ChiliPDF plugin CSS stylesheets
  PLUGIN_CSS_DIR = Rails.root.join('public','plugin_assets', 'chili_pdf', 'stylesheets')

  # Standard <script>-tag for ProtoTypeJS javascript file
  PROTOTYPE_SCRIPT_TAG = "<script src='/javascripts/prototype.js' type='text/javascript'></script>\n"


  # Public: Generates CSS link tags for all CSS files in the
  #         plugin_assets/chili_pdf/stylesheets directory.
  #
  # Returns: String of link tags separated by a newline character.
  def chili_pdf_stylesheets(wants_html)
    normalize_css_src_tags_in(chili_pdf_css_link_tags, wants_html)
  end


  # Public: Generate JS script tags for all JavaScript files in the
  #         plugin_assets/chili_pdf/stylesheets directory (escaped
  #         appropriately for the request type).
  #
  # Returns: string of <script> tags separated by a newline character
  def chili_pdf_javascripts(wants_html)
    normalize_js_src_tags_in(chili_pdf_script_tags, wants_html)
  end


  # Public: Converts 'href' attributes of any CSS link tags
  #         tags to be compatible with the `wkhtmltopdf` executable
  #         requirements, using "file://"-format for all local assets.
  #
  # content    - the String of HTML content to normalize/update
  # wants_html - boolean of whether to actually modify or not (added to
  #              keep excessive boolean logic out of views)
  #
  # Returns content un-modified if wants_html is true. Otherwise returns
  #         the content string with the modified 'href' attribute on all
  #         locally-hosted <link>-tags in content.
  def normalize_css_src_tags_in(content, wants_html = false)
    return content if wants_html

    doc = ::Nokogiri::HTML(content)
    doc.xpath('//link[@href]').each do |link_tag|
      link_tag['href'] = TagMangler.new(link_tag['href']).to_local_src
    end
    doc.to_s
  end


  # Public: Converts 'src' attributes of any <script> tags (with a 'src'
  #         attribute) to be compatible with the `wkhtmltopdf` executable
  #         requirements, using "file://"-format for all local assets.
  #
  # content    - the String of HTML content to normalize/update
  # wants_html - boolean of whether to actually modify or not (added to
  #              keep excessive boolean logic out of views)
  #
  # Returns content un-modified if wants_html is true. Otherwise returns
  #         the content string with the modified 'src' attribute on all
  #         locally-hosted <script>-tags in content.
  def normalize_js_src_tags_in(content, wants_html = false)
    update_src_tag_of(:script, content, wants_html)
  end


  # Public: Converts 'src' attributes of any <img> tags (with a 'src'
  #         attribute) to be compatible with the `wkhtmltopdf` executable
  #         requirements, using "file://"-format for all local assets.
  #
  # content    - the String of HTML content to normalize/update
  # wants_html - boolean of whether to actually modify or not (added to
  #              keep excessive boolean logic out of views)
  #
  # Returns content un-modified if wants_html is true. Otherwise returns
  #         the content string with the modified 'src' attribute on all
  #         locally-hosted <img>-tags in content.
  def update_img_src_tags_of(content, wants_html = false)
    update_src_tag_of(:img, content, wants_html)
  end


  private
    # Generate list of default CSS link tags for the ChiliPDF plugin
    #
    # Returns String of <link>-tags for each file in the plugin's stylesheets
    # directory, separated by a newline character.
    def chili_pdf_css_link_tags
      tag_list(:css, PLUGIN_CSS_DIR) {|filename|
        "<link href='/plugin_assets/chili_pdf/stylesheets/#{filename}' rel='stylesheet' type='text/css' />\n"
      }.join("\n")
    end


    # Generate list of default (JavaScript) script tags for the ChiliPDF plugin
    #
    # Returns String of <script>-tags for each file in the plugin's 'javascripts'
    # directory, separated by a newline character.
    def chili_pdf_script_tags
      PROTOTYPE_SCRIPT_TAG +
      tag_list(:js, PLUGIN_JS_DIR) {|filename|
        "<script src='/plugin_assets/chili_pdf/javascripts/#{filename}' type='text/javascript'></script>"
      }.join("\n")
    end


    # Updates the value of the 'src' attribute of any `tag_type` tags
    # contained in `content` to be compatible with the `wkhtmltopdf`
    # executable. If `wants_html` is falsey, no modifications are made
    # to content.
    #
    # tag_type   - String-link object which returns the tag to look for in
    #              'content' when #to_s is called on it.
    # content    - String of the HTML content to search for `tag_type' in
    # wants_html - whether to actually modify the source tags (added to
    #              remove excessive/unnecessary boolean logic from view
    #              templates)
    def update_src_tag_of(tag_type, content, wants_html)
      return content if wants_html
      doc = ::Nokogiri::HTML(content)
      doc.xpath("//#{tag_type.to_s}[@src]").each do |script_tag|
        script_tag['src'] = TagMangler.new(script_tag['src']).to_local_src
      end
      doc.to_s
    end


    # Generate list of content for each file based on the results of the
    # block passed in. Useful for generating a series of tags for all files
    # matching a particular file type in a specified directory.
    #
    # file_ext - the file extension to search for in the src_dir
    # src_dir  - the directory to search for file with the specified
    #            file extension (file_ext)
    # &block   - code to execute on each matching filename (filename is
    #            passed in as a parameter to &block)
    # Returns an Array of the results of the &block executions.
    def tag_list(file_ext, src_dir, &block)
      Dir.glob("#{src_dir}/*#{file_ext.to_s}").collect do |file_path|
        yield file_path.split("/").last
      end
    end
end
