require File.dirname(__FILE__) + '/../test_helper'

class ConfigTest < ActiveSupport::TestCase
  setup do
    Setting["plugin_chili_pdf"] = HashWithIndifferentAccess.new(ChiliPDF::Config.defaults)
  end

  context '#header_values' do
    context 'when no customizations have taken place' do
      should "return the 'defaults' values for the header fields" do
        defaults = {
                     'left'   => ChiliPDF::Config.defaults[ChiliPDF::Config::HEADER_LEFT_KEYNAME],
                     'center' => ChiliPDF::Config.defaults[ChiliPDF::Config::HEADER_CENTER_KEYNAME],
                     'right'  => ChiliPDF::Config.defaults[ChiliPDF::Config::HEADER_RIGHT_KEYNAME]
                   }
        assert_equal defaults, ChiliPDF::Config.header_values
      end
    end

    context 'when the content has been customized' do
      setup do
        @left   = 'left_header'
        @center = 'center header'
        @right  = 'right header'

        Setting["plugin_chili_pdf"] = {ChiliPDF::Config::HEADER_LEFT_KEYNAME => @left,
                                       ChiliPDF::Config::HEADER_CENTER_KEYNAME => @center,
                                       ChiliPDF::Config::HEADER_RIGHT_KEYNAME => @right}
      end

      should "return the customized values for the header fields" do
        assert_equal @left, ChiliPDF::Config.header_values[:left]
        assert_equal @center, ChiliPDF::Config.header_values[:center]
        assert_equal @right, ChiliPDF::Config.header_values[:right]
      end
    end
  end

  context '#footer_values' do
    context 'when no customizations have taken place' do
      should "return the 'defaults' values for the footer fields" do
        defaults = {
                     'left'   => ChiliPDF::Config.defaults[ChiliPDF::Config::FOOTER_LEFT_KEYNAME],
                     'center' => ChiliPDF::Config.defaults[ChiliPDF::Config::FOOTER_CENTER_KEYNAME],
                     'right'  => ChiliPDF::Config.defaults[ChiliPDF::Config::FOOTER_RIGHT_KEYNAME]
                   }
        assert_equal defaults, ChiliPDF::Config.footer_values
      end
    end

    context 'when the footer content has been customized' do
      setup do
        @left   = 'left footer'
        @center = 'center footer'
        @right  = 'right footer'

        Setting["plugin_chili_pdf"] = {ChiliPDF::Config::FOOTER_LEFT_KEYNAME => @left,
                                       ChiliPDF::Config::FOOTER_CENTER_KEYNAME => @center,
                                       ChiliPDF::Config::FOOTER_RIGHT_KEYNAME => @right}
      end

      should "return the customized values for the footer fields" do
        assert_equal @left, ChiliPDF::Config.footer_values[:left]
        assert_equal @center, ChiliPDF::Config.footer_values[:center]
        assert_equal @right, ChiliPDF::Config.footer_values[:right]
      end
    end
  end
end
