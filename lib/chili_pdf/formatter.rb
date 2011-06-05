module ChiliPDF
  module Formatter
    extend self

    def render_options(filename)
      {:pdf => filename}
    end
  end
end
