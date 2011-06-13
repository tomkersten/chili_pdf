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

  settings :partial => 'settings/chili_pdf_settings',
           :default => ChiliPDF::Config.defaults
end

Dispatcher.to_prepare :chili_pdf do
  require_dependency 'principal'
  require_dependency 'user'
  User.send(:include, UserPatch) unless User.included_modules.include? UserPatch
end
