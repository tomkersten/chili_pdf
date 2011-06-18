ActionController::Routing::Routes.draw do |map|
  map.connect 'projects/:project_id/wiki.pdf', :controller => 'extended_wiki', :action => 'show', :format => 'pdf'
  map.connect 'projects/:project_id/wiki/:id.pdf', :controller => 'extended_wiki', :action => 'show', :format => 'pdf'
end
