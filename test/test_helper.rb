require 'test/unit'

require File.expand_path(File.dirname(__FILE__) + '/../../../../test/test_helper')

# Ensure that we are using the temporary fixture path
Engines::Testing.set_fixture_path

require 'chili_pdf'
include ChiliPDF

module HeaderHelpers
  def set_header_field_to(value)
    ChiliPDF::Config.update({ChiliPDF::Config::HEADER_LEFT_KEYNAME => value})
  end

  def header_value
    @formatter.render_options[:header][:left]
  end

  def disable_footers
    ChiliPDF::Config.update(ChiliPDF::Config::FOOTER_ENABLED_KEYNAME => ChiliPDF::Config::DISABLED_VALUE)
  end

  def enable_footers
    ChiliPDF::Config.update({ChiliPDF::Config::FOOTER_ENABLED_KEYNAME => ChiliPDF::Config::ENABLED_VALUE})
  end

  def enable_headers
    ChiliPDF::Config.update({ChiliPDF::Config::HEADER_ENABLED_KEYNAME => ChiliPDF::Config::ENABLED_VALUE})
  end

  def disable_headers
    ChiliPDF::Config.update({ChiliPDF::Config::HEADER_ENABLED_KEYNAME => ChiliPDF::Config::DISABLED_VALUE})
  end
end

