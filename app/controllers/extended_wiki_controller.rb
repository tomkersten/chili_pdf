class ExtendedWikiController < WikiController
  unloadable

  helper 'chili_pdf'

  def show
    super
    unless performed? # Prevent double render
      respond_to do |format|
        format.html {render :template => 'wiki/show'}
        format.pdf {
          filename = "#{@project.name.underscore}_#{@page.title}".gsub(/\s/,'')
          render :pdf => filename,
                 :template => 'extended_wiki/show.pdf.html.erb',
                 :page_size => "Letter",
                 :user_style_sheet => "#{Rails.root}/public/plugin_assets/chili_pdf/stylesheets/pdf.css",
                 :margin => {
                   :top    => "0.5in",
                   :bottom => "0.5in",
                   :left   => "0.5in",
                   :right  => "0.5in"
                 },
                 :layout => 'pdf.pdf.erb'
        }
      end
    end
  end
end
