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
    setup do
      ChiliPDF::Config.update({ChiliPDF::Config::FOOTER_ENABLED_KEYNAME => ChiliPDF::Config::ENABLED_VALUE})
    end

    should 'include footer options' do
      assert ChiliPDF::Config.footer_enabled?
      assert ChiliPDF::Formatter.render_options('filename.pdf').has_key?(:footer)
    end
  end

  context 'when footers are disabled' do
    setup do
      ChiliPDF::Config.update(ChiliPDF::Config::FOOTER_ENABLED_KEYNAME => ChiliPDF::Config::DISABLED_VALUE)
    end

    should "not include a 'footer' key" do
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

  context "replacing 'dynamic tokens' with expected content" do
    should "substitues '{{current_page}}' with '[page]'" do
      ChiliPDF::Config.update({ChiliPDF::Config::HEADER_LEFT_KEYNAME => "{{current_page}}"})

      assert ChiliPDF::Config.footer_enabled?
      assert_equal '[page]', ChiliPDF::Formatter.render_options('filename.pdf')[:header][:left]
    end

    should "substitues '{{total_pages}}' with '[topage]'" do
      ChiliPDF::Config.update({ChiliPDF::Config::HEADER_LEFT_KEYNAME => "{{total_pages}}"})

      assert ChiliPDF::Config.footer_enabled?
      assert_equal '[topage]', ChiliPDF::Formatter.render_options('filename.pdf')[:header][:left]
    end

    should "substitues '{{datestamp}}' with a date formated as 'DD-MON-YYYY'" do
      ChiliPDF::Config.update({ChiliPDF::Config::HEADER_LEFT_KEYNAME => "{{datestamp}}"})
      todays_date = Time.now.strftime('%d-%b-%Y')

      assert ChiliPDF::Config.footer_enabled?
      assert_equal todays_date, ChiliPDF::Formatter.render_options('filename.pdf')[:header][:left]
    end

    context "when a page title is supplied" do
      should "substitues '{{page_title}}' with a string value passed in as the 'page_title' argument" do
        ChiliPDF::Config.update({ChiliPDF::Config::HEADER_LEFT_KEYNAME => "{{page_title}}"})
        custom_title = 'Custom title'

        assert ChiliPDF::Config.footer_enabled?
        assert_equal custom_title, ChiliPDF::Formatter.render_options('filename.pdf', custom_title)[:header][:left]
      end
    end

    context "when a page title is not supplied" do
      should "substitues '{{page_title}}' with the default page title value '#{ChiliPDF::Formatter::DEFAULT_PAGE_TITLE}'" do
        ChiliPDF::Config.update({ChiliPDF::Config::HEADER_LEFT_KEYNAME => "{{page_title}}"})

        assert ChiliPDF::Config.footer_enabled?
        assert_equal ChiliPDF::Formatter::DEFAULT_PAGE_TITLE, ChiliPDF::Formatter.render_options('filename.pdf')[:header][:left]
      end
    end

    # The next couple are slightly hacky (or...maybe super-hacky)
    should "substitues '{{current_year}}' with the current year (formated as 'YYYY')" do
      ChiliPDF::Config.update({ChiliPDF::Config::HEADER_LEFT_KEYNAME => "{{current_year}}"})
      todays_date = Time.now.strftime('%Y')

      assert ChiliPDF::Config.footer_enabled?
      assert_equal todays_date, ChiliPDF::Formatter.render_options('filename.pdf')[:header][:left]
    end

    should "substitues '{{current_quarter}}' with a string value of 1, 2, 3, 4...depending on month of year" do
      ChiliPDF::Config.update({ChiliPDF::Config::HEADER_LEFT_KEYNAME => "{{current_quarter}}"})
      month = Time.now.strftime('%m').to_i
      expected = (((month - 1) / 3) + 1).to_s

      assert ChiliPDF::Config.footer_enabled?
      assert_equal expected, ChiliPDF::Formatter.render_options('filename.pdf')[:header][:left]
    end
  end
end
