module ChiliPDF
  module Formatter
    extend self

    HEADER_FOOTER_FONT_SIZE = 8
    DEFAULT_MARGIN = '0.5in'
    DEFAULT_PAGE_SIZE = "Letter"

    def render_options(filename, header_title = nil)
      header_title ||= filename

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
      default_options.merge!(header_options(header_title)) if ChiliPDF::Config.header_enabled?
      default_options
    end

    private
      def datestamp
        Time.now.strftime('%d-%b-%Y')
      end

      def footer_options
        {:footer => {
          :font_size => 8,
          :left => datestamp,
          :right => '[page]/[topage]',
          :line => true,
          :spacing => 2
        }}
      end

      def header_options(title)
        {:header => {
          :font_size => HEADER_FOOTER_FONT_SIZE,
          :left => title,
          :line => true,
          :spacing => 2
        }}
      end
  end
end
