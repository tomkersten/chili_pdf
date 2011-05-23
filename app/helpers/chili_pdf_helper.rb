module ChiliPdfHelper
  # Taken almost verbatim from wicked_pdf gem
  def chili_pdf_stylesheets
    css_dir = Rails.root.join('public','plugin_assets', 'chili_pdf', 'stylesheets')
    css_file_list = Dir.glob("#{css_dir}/*css")
    css_file_list.collect { |css_file|
      "<style type='text/css'>#{File.read(css_file)}</style>"
    }.join("\n")
  end
end
