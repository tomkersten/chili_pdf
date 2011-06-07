module ChiliPDF
  module Formatter
    extend self

    def render_options(filename)
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
        :layout => 'pdf.pdf.erb'
      }
    end
  end
end
