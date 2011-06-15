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
      ChiliPDF::Formatter.new(filename, page_title, wants_html_version?)
    end

    def filename
      "#{@project.name.underscore}_#{@page.title}".gsub(/\s/,'')
    end

    def page_title
      "#{@project.name}, #{@page.title}"
    end

    def wants_html_version?
      @requesting_html_version = params[:as_html] == 'true' || request.format.html?
    end
end
