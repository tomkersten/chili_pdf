ActionController::Routing::Routes.draw do |map|
  map.connect 'projects/:project_id/wiki/:id.:format', :controller => 'extended_wiki', :action => 'show', :requirements => {:format => /pdf/}
end
