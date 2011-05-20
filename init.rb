require 'redmine'
require 'chili_pdf'
require 'wicked_pdf'
require 'dispatcher'

Redmine::Plugin.register :chili_pdf do
  name 'Chili PDF plugin'
  author 'Tom Kersten'
  description "Implements/Enhances PDF-export functionality using the Webkit rendering engine (via the 'wkhtmltopdf' executable)."
  version ChiliPDF::VERSION
  url 'https://github.com/tomkersten/chili_pdf'
  author_url 'http://tomkersten.com/'
end

Dispatcher.to_prepare do
  require_dependency 'application_controller'
  require 'application_controller_patch'
  unless ApplicationController.included_modules.include? ApplicationControllerPatch
    ApplicationController.send(:include, ApplicationControllerPatch)
  end
end
