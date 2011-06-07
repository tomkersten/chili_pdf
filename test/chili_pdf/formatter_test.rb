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

  def test_default_header_options_no_header_title
    filename = 'filename.pdf'
    default_header = {:font_size => 8, :left => filename, :line => true}
    render_options = Formatter.render_options(filename)
    assert_equal default_header, render_options[:header]
  end

  def test_default_header_options_with_header_title
    header_text = 'Header Title'
    render_options = Formatter.render_options('filename.pdf', header_text)

    default_header = {:font_size => 8, :left => header_text, :line => true}
    assert_equal default_header, render_options[:header]
  end

  def test_default_footer_options
    date = Time.now.strftime('%d-%b-%Y')
    default_footer = {:font_size => 8, :left => date, :right => "[page]/[topage]", :line => true}
    render_options = Formatter.render_options('filename.pdf')
    assert_equal default_footer, render_options[:footer]
  end
end
