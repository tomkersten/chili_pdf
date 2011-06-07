require 'test_helper'

class FormatterTest < Test::Unit::TestCase
  def setup
  end

  def test_render_options_returns_hash_with_pdf_filename_set
    render_options = Formatter.render_options('filename.pdf')
    assert render_options[:pdf] == 'filename.pdf'
  end

  def test_default_template
    render_options = Formatter.render_options('filename.pdf')
    assert render_options[:template] == 'extended_wiki/show.pdf.html.erb'
  end

  def test_default_page_size
    render_options = Formatter.render_options('filename.pdf')
    assert render_options[:page_size] == 'Letter'
  end

  def test_default_margins
    default_margins = {:top => "0.5in", :bottom => "0.5in", :left => "0.5in", :right => "0.5in"}
    render_options = Formatter.render_options('filename.pdf')
    assert render_options[:margin] == default_margins
  end

  def test_default_layout
    render_options = Formatter.render_options('filename.pdf')
    assert render_options[:layout] == 'pdf.pdf.erb'
  end
end
