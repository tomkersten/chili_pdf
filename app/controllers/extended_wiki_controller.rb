class ExtendedWikiController < WikiController
  unloadable

  helper 'chili_pdf'

  def show
    super
    unless performed? # Prevent double render
      respond_to do |format|
        format.pdf {render pdf_render_options}
      end
    end
  end

  private
    def pdf_render_options
      ChiliPDF::Formatter.render_options(filename, @page.title)
    end

    def filename
      "#{@project.name.underscore}_#{@page.title}".gsub(/\s/,'')
    end
end
