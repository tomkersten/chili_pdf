module ChiliPDF
  module Config
    extend self

    PLUGIN_KEYNAME = 'plugin_chili_pdf'
    ENABLED_VALUE = '1'
    DISABLED_VALUE = '0'
    FOOTER_ENABLED_KEYNAME = 'footer_enabled'
    HEADER_ENABLED_KEYNAME = 'header_enabled'

    def footer_enabled?
      footer_enabled == ENABLED_VALUE
    end

    def header_enabled?
      header_enabled == ENABLED_VALUE
    end

    # Accepts anything which responds to '[]' and '.has_key?' # (Hash-like objects)
    #
    # Utilizes following keys (values of):
    #   - HEADER_ENABLED_KEYNAME
    #   - FOOTER_ENABLED_KEYNAME
    def update(options)
      Setting[PLUGIN_KEYNAME] = formatted_hash(options)
      true
    end

    private
      def footer_enabled
        plugin_settings[FOOTER_ENABLED_KEYNAME]
      end

      def header_enabled
        plugin_settings[HEADER_ENABLED_KEYNAME]
      end

      def plugin_settings
        HashWithIndifferentAccess.new(Setting[PLUGIN_KEYNAME])
      end

      def formatted_hash(options)
        HashWithIndifferentAccess.new({HEADER_ENABLED_KEYNAME => options[HEADER_ENABLED_KEYNAME],
                                       FOOTER_ENABLED_KEYNAME => options[FOOTER_ENABLED_KEYNAME]})
      end
  end
end
