require 'test_helper'

class FormatterTest < Test::Unit::TestCase
  def setup
  end

  def test_render_options_returns_hash_with_pdf_filename_set
    render_options = Formatter.render_options('filename.pdf')
    assert render_options[:pdf] == 'filename.pdf'
  end
end
