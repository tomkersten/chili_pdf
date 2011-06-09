require 'test_helper'

class FormatterTest < Test::Unit::TestCase
  def test_default_layout
    render_options = Formatter.render_options('filename.pdf')
    assert_equal 'pdf.pdf.erb', render_options[:layout]
  end

  def test_render_options_returns_hash_with_pdf_filename_set
    render_options = Formatter.render_options('filename.pdf')
    assert_equal 'filename.pdf', render_options[:pdf]
  end

  def test_default_template
    render_options = Formatter.render_options('filename.pdf')
    assert_equal 'extended_wiki/show.pdf.html.erb', render_options[:template]
  end

  def test_default_page_size
    render_options = Formatter.render_options('filename.pdf')
    assert_equal 'Letter', render_options[:page_size]
  end

  def test_default_margins
    default_margins = {:top => "0.5in", :bottom => "0.5in", :left => "0.5in", :right => "0.5in"}
    render_options = Formatter.render_options('filename.pdf')
    assert_equal default_margins, render_options[:margin]
  end

  context 'when footers are enabled' do
    should 'include footer options' do
      ChiliPDF::Config.update({ChiliPDF::Config::FOOTER_ENABLED_KEYNAME => ChiliPDF::Config::ENABLED_VALUE})

      assert ChiliPDF::Config.footer_enabled?
      assert ChiliPDF::Formatter.render_options('filename.pdf').has_key?(:footer)
    end
  end

  context 'when footers are disabled' do
    should "not include a 'footer' key" do
      ChiliPDF::Config.update(ChiliPDF::Config::FOOTER_ENABLED_KEYNAME => ChiliPDF::Config::DISABLED_VALUE)

      assert !ChiliPDF::Config.footer_enabled?
      assert !ChiliPDF::Formatter.render_options('filename.pdf').has_key?(:footer)
    end
  end

  context 'when headers are enabled' do
    should 'include header options' do
      ChiliPDF::Config.update({ChiliPDF::Config::HEADER_ENABLED_KEYNAME => ChiliPDF::Config::ENABLED_VALUE})

      assert ChiliPDF::Config.header_enabled?
      assert ChiliPDF::Formatter.render_options('filename.pdf').has_key?(:header)
    end
  end

  context 'when headers are disabled' do
    should "not include a 'header' key" do
      ChiliPDF::Config.update(ChiliPDF::Config::HEADER_ENABLED_KEYNAME => ChiliPDF::Config::DISABLED_VALUE)

      assert !ChiliPDF::Config.header_enabled?
      assert !ChiliPDF::Formatter.render_options('filename.pdf').has_key?(:header)
    end
  end
end
