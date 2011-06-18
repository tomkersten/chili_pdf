module ChiliPDF
  module Config
    extend self

    PLUGIN_KEYNAME = 'plugin_chili_pdf'
    ENABLED_VALUE = '1'
    DISABLED_VALUE = '0'
    FOOTER_ENABLED_KEYNAME = 'footer_enabled'
    HEADER_ENABLED_KEYNAME = 'header_enabled'
    CUSTOM_CSS_KEYNAME      = 'custom_css'
    CUSTOM_JS_KEYNAME       = 'custom_javascript'

    HEADER_LEFT_KEYNAME   = :header_content_left
    HEADER_CENTER_KEYNAME = :header_content_center
    HEADER_RIGHT_KEYNAME  = :header_content_right
    FOOTER_LEFT_KEYNAME   = :footer_content_left
    FOOTER_CENTER_KEYNAME = :footer_content_center
    FOOTER_RIGHT_KEYNAME  = :footer_content_right

    HEADER_LEFT_DEFAULT_VALUE   = '{{page_title}}'
    HEADER_CENTER_DEFAULT_VALUE = ''
    HEADER_RIGHT_DEFAULT_VALUE  = ''
    FOOTER_LEFT_DEFAULT_VALUE   = '{{datestamp}}'
    FOOTER_CENTER_DEFAULT_VALUE = ''
    FOOTER_RIGHT_DEFAULT_VALUE  = '{{current_page}}/{{total_pages}}'
    CUSTOM_CSS_DEFAULT_VALUE    = <<END_OF_CSS_DEF
<!-- stylesheet link example, uncomment & modify if you like -->
<!-- <link href='/stylesheets/your_custom.css' rel='stylesheet' type='text/css' />

<!-- inline example -->
<style type="text/css">
  //#custom-pdf-styles h2 {color: red;}
</style>
END_OF_CSS_DEF

    CUSTOM_JS_DEFAULT_VALUE     = <<END_OF_JS_DEF
<!-- Script tag link example. Uncomment & modify if you like.  -->
<!-- <script src='/javascripts/your_custom.js' type='text/javascript' />

<!-- Inline JavaScript example -->
<script type="text/javascript">
  // Your custom-inline JS here
</script>
END_OF_JS_DEF

    def defaults
      {
        FOOTER_ENABLED_KEYNAME => ENABLED_VALUE,
        HEADER_ENABLED_KEYNAME => ENABLED_VALUE,
        HEADER_LEFT_KEYNAME    => HEADER_LEFT_DEFAULT_VALUE,
        HEADER_CENTER_KEYNAME  => HEADER_CENTER_DEFAULT_VALUE,
        HEADER_RIGHT_KEYNAME   => HEADER_RIGHT_DEFAULT_VALUE,
        FOOTER_LEFT_KEYNAME    => FOOTER_LEFT_DEFAULT_VALUE,
        FOOTER_CENTER_KEYNAME  => FOOTER_CENTER_DEFAULT_VALUE,
        FOOTER_RIGHT_KEYNAME   => FOOTER_RIGHT_DEFAULT_VALUE,
        CUSTOM_CSS_KEYNAME     => CUSTOM_CSS_DEFAULT_VALUE,
        CUSTOM_JS_KEYNAME      => CUSTOM_JS_DEFAULT_VALUE
      }
    end

    # Public: Returns whether the footer will be printed when exporting
    #         a PDF.
    #
    # Returns either true or false.
    def footer_enabled?
      footer_enabled == ENABLED_VALUE
    end

    # Public: Returns whether the header will be printed when exporting
    #         a PDF.
    #
    # Returns either true or false.
    def header_enabled?
      header_enabled == ENABLED_VALUE
    end

    # Public: Accepts anything which responds to '[]' and '.has_key?'
    #         (ie: Hash-like objects)
    #
    # Utilizes following keys (values of):
    #   - HEADER_ENABLED_KEYNAME
    #   - FOOTER_ENABLED_KEYNAME
    #
    # Returns true. Always.
    def update(options)
      Setting[PLUGIN_KEYNAME] = defaults.merge(options)
      true
    end

    def header_values
      default_header_values.merge(stored_header_settings)
    end

    def footer_values
      default_footer_values.merge(stored_footer_settings)
    end

    def custom_css
      if plugin_settings[CUSTOM_CSS_KEYNAME].blank?
        CUSTOM_CSS_DEFAULT_VALUE
      else
        plugin_settings[CUSTOM_CSS_KEYNAME]
      end
    end

    def custom_js
      if plugin_settings[CUSTOM_JS_KEYNAME].blank?
        CUSTOM_JS_DEFAULT_VALUE
      else
        plugin_settings[CUSTOM_JS_KEYNAME]
      end
    end

    private
      def default_header_values
        {:left => HEADER_LEFT_DEFAULT_VALUE,
         :center => HEADER_CENTER_DEFAULT_VALUE,
         :right => HEADER_RIGHT_DEFAULT_VALUE}
      end

      def stored_header_settings
        {:left => plugin_settings[HEADER_LEFT_KEYNAME],
         :center => plugin_settings[HEADER_CENTER_KEYNAME],
         :right => plugin_settings[HEADER_RIGHT_KEYNAME]}.reject {|k,v| v.nil?}
      end

      def default_footer_values
        {:left  => FOOTER_LEFT_DEFAULT_VALUE,
         :center => FOOTER_CENTER_DEFAULT_VALUE,
         :right  => FOOTER_RIGHT_DEFAULT_VALUE}
      end

      def stored_footer_settings
        {:left => plugin_settings[FOOTER_LEFT_KEYNAME],
         :center => plugin_settings[FOOTER_CENTER_KEYNAME],
         :right => plugin_settings[FOOTER_RIGHT_KEYNAME]}.reject {|k,v| v.nil?}
      end

      def footer_enabled
        plugin_settings[FOOTER_ENABLED_KEYNAME]
      end

      def header_enabled
        plugin_settings[HEADER_ENABLED_KEYNAME]
      end

      def plugin_settings
        Setting[PLUGIN_KEYNAME]
      end
  end
end
