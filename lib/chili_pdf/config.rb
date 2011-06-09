module ChiliPDF
  module Config
    extend self

    PLUGIN_KEYNAME = 'plugin_chili_pdf'
    ENABLED_VALUE = '1'
    DISABLED_VALUE = '0'
    FOOTER_ENABLED_KEYNAME = 'footer_enabled'
    HEADER_ENABLED_KEYNAME = 'header_enabled'

    HEADER_LEFT_KEYNAME   = 'header_content_left'
    HEADER_CENTER_KEYNAME = 'header_content_center'
    HEADER_RIGHT_KEYNAME  = 'header_content_right'
    FOOTER_LEFT_KEYNAME   = 'footer_content_left'
    FOOTER_CENTER_KEYNAME = 'footer_content_center'
    FOOTER_RIGHT_KEYNAME  = 'footer_content_right'

    HEADER_LEFT_DEFAULT_VALUE   = 'default left header'
    HEADER_CENTER_DEFAULT_VALUE = 'default center header'
    HEADER_RIGHT_DEFAULT_VALUE  = 'default right header'
    FOOTER_LEFT_DEFAULT_VALUE   = 'default left footer'
    FOOTER_CENTER_DEFAULT_VALUE = 'default center footer'
    FOOTER_RIGHT_DEFAULT_VALUE  = 'default right footer'

    def defaults
      {
        FOOTER_ENABLED_KEYNAME => ENABLED_VALUE,
        HEADER_ENABLED_KEYNAME => ENABLED_VALUE,
        HEADER_LEFT_KEYNAME    => HEADER_LEFT_DEFAULT_VALUE,
        HEADER_CENTER_KEYNAME  => HEADER_CENTER_DEFAULT_VALUE,
        HEADER_RIGHT_KEYNAME   => HEADER_RIGHT_DEFAULT_VALUE,
        FOOTER_LEFT_KEYNAME    => FOOTER_LEFT_DEFAULT_VALUE,
        FOOTER_CENTER_KEYNAME  => FOOTER_CENTER_DEFAULT_VALUE,
        FOOTER_RIGHT_KEYNAME   => FOOTER_RIGHT_DEFAULT_VALUE
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
      Setting[PLUGIN_KEYNAME] = formatted_hash(options)
      true
    end

    def header_values
      default_header_values.merge(stored_header_settings)
    end

    def footer_values
      default_footer_values.merge(stored_footer_settings)
    end

    private
      def default_header_values
        formatted_hash({:left => HEADER_LEFT_DEFAULT_VALUE,
                        :center => HEADER_CENTER_DEFAULT_VALUE,
                        :right => HEADER_RIGHT_DEFAULT_VALUE})
      end

      def stored_header_settings
        formatted_hash({:left => plugin_settings[HEADER_LEFT_KEYNAME],
                        :center => plugin_settings[HEADER_CENTER_KEYNAME],
                        :right => plugin_settings[HEADER_RIGHT_KEYNAME]}).reject {|k,v| v.nil?}
      end

      def default_footer_values
        formatted_hash({:left  => FOOTER_LEFT_DEFAULT_VALUE,
                       :center => FOOTER_CENTER_DEFAULT_VALUE,
                       :right  => FOOTER_RIGHT_DEFAULT_VALUE})
      end

      def stored_footer_settings
        formatted_hash({:left => plugin_settings[FOOTER_LEFT_KEYNAME],
                        :center => plugin_settings[FOOTER_CENTER_KEYNAME],
                        :right => plugin_settings[FOOTER_RIGHT_KEYNAME]}).reject {|k,v| v.nil?}
      end

      def footer_enabled
        plugin_settings[FOOTER_ENABLED_KEYNAME]
      end

      def header_enabled
        plugin_settings[HEADER_ENABLED_KEYNAME]
      end

      def plugin_settings
        HashWithIndifferentAccess.new(Setting[PLUGIN_KEYNAME])
      end

      def formatted_hash(hash)
        HashWithIndifferentAccess.new(hash)
      end
  end
end
