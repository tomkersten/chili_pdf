ActionController::Routing::Routes.draw do |map|
  map.connect 'projects/:project_id/wiki/:id.pdf', :controller => 'extended_wiki', :action => 'show', :format => 'pdf'
  map.connect 'asset_url_converter/convert', :controller => 'asset_url_converter', :action => 'convert'
end
