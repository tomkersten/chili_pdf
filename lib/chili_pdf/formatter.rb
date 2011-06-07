module ChiliPDF
  module Formatter
    extend self

    def render_options(filename, header_title = nil)
      header_title ||= filename

      {
        :pdf => filename,
        :template => 'extended_wiki/show.pdf.html.erb',
        :page_size => "Letter",
        :margin => {
          :top => "0.5in",
          :bottom => "0.5in",
          :left => "0.5in",
          :right => "0.5in"
        },
        :header => {
          :font_size => 8,
          :left => header_title,
          :line => true
        },
        :footer => {
          :font_size => 8,
          :left => datestamp,
          :right => '[page]/[topage]',
          :line => true
        },
        :layout => 'pdf.pdf.erb'
      }
    end

    private
      def datestamp
        Time.now.strftime('%d-%b-%Y')
      end
  end
end
