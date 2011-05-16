require 'redmine'
require 'chili_pdf'

Redmine::Plugin.register :chili_pdf do
  name 'Chili PDF plugin'
  author 'Tom Kersten'
  description "Implements/Enhances PDF-export functionality using the Webkit rendering engine (via the 'wkhtmltopdf' executable)."
  version ChiliPDF::VERSION
  url 'https://github.com/tomkersten/chili_pdf'
  author_url 'http://tomkersten.com/'
end
