class WikiFormatHookListener < Redmine::Hook::ViewListener
  def view_wiki_show_other_formats(options = {})
    options[:link_builder].link_to "PDF", :url => options[:url_params].merge({:format => 'pdf'})
  end
end
