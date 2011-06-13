class ExtendedWikiController < WikiController
  unloadable

  helper 'chili_pdf'

  def show
    super
    unless performed? # Prevent double render
      respond_to do |format|
        format.pdf {render formatter.render_options}
      end
    end
  end

  private
    def formatter
      ChiliPDF::Formatter.new(filename, page_title)
    end

    def filename
      "#{@project.name.underscore}_#{@page.title}".gsub(/\s/,'')
    end

    def page_title
      "#{@project.name}, #{@page.title}"
    end
end
