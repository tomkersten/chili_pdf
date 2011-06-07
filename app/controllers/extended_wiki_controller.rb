class ExtendedWikiController < WikiController
  unloadable

  helper 'chili_pdf'

  def show
    super
    unless performed? # Prevent double render
      respond_to do |format|
        format.pdf {render ChiliPDF::Formatter.render_options(filename)}
      end
    end
  end

  private
    def filename
      "#{@project.name.underscore}_#{@page.title}".gsub(/\s/,'')
    end
end
