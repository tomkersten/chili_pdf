module ChiliPDF
  module Formatter
    extend self

    HEADER_FOOTER_FONT_SIZE = 8
    DEFAULT_MARGIN = '0.5in'
    DEFAULT_PAGE_SIZE = "Letter"

    def render_options(filename)
      default_options = {
        :pdf => filename,
        :template => 'extended_wiki/show.pdf.html.erb',
        :page_size => DEFAULT_PAGE_SIZE,
        :margin => {
          :top    => DEFAULT_MARGIN,
          :bottom => DEFAULT_MARGIN,
          :left   => DEFAULT_MARGIN,
          :right  => DEFAULT_MARGIN
        },
        :layout => 'pdf.pdf.erb'
      }

      default_options.merge!(footer_options) if ChiliPDF::Config.footer_enabled?
      default_options.merge!(header_options) if ChiliPDF::Config.header_enabled?
      default_options
    end

    private
      def footer_options
        {:footer => {
          :font_size => 8,
          :line => true,
          :spacing => 2
        }.merge(ChiliPDF::Config.footer_values)}
      end

      def header_options
        {:header => {
          :font_size => HEADER_FOOTER_FONT_SIZE,
          :line => true,
          :spacing => 2
        }.merge(ChiliPDF::Config.header_values)}
      end
  end
end
