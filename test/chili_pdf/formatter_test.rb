require 'test_helper'

class FormatterTest < Test::Unit::TestCase
  include HeaderHelpers

  def setup
    @formatter = Formatter.new('filename.pdf')
  end

  context "#render_options" do
    should "render_options returns hash with pdf filename set" do
      assert_equal 'filename.pdf', Formatter.new('filename.pdf').render_options[:pdf]
    end

    should "set the return the default layout of 'pdf.pdf.erb'" do
      assert_equal ChiliPDF::Formatter::DEFAULT_LAYOUT, @formatter.render_options[:layout]
    end

    should "set 'extended_wiki/show.pdf.html.erb' as the default template" do
      assert_equal ChiliPDF::Formatter::DEFAULT_VIEW_TEMPLATE, @formatter.render_options[:template]
    end

    should "set the default page_size to be 'Letter'" do
      assert_equal ChiliPDF::Formatter::DEFAULT_PAGE_SIZE, @formatter.render_options[:page_size]
    end

    should "set the default margins" do
      def_margin = ChiliPDF::Formatter::DEFAULT_MARGIN
      default_margins = {:top => def_margin, :bottom => def_margin, :left => def_margin, :right => def_margin}
      assert_equal default_margins, @formatter.render_options[:margin]
    end

    context "enabling/disabling viewing the underlying HTML of the PDF" do
      should "set :show_as_html key to true when true is specified" do
        formatter = Formatter.new('filename.pdf', 'title', true)
        assert formatter.render_options[:show_as_html]
      end

      should "set :show_as_html key to false when false is specified" do
        formatter = Formatter.new('filename.pdf', 'title', false)
        assert !formatter.render_options[:show_as_html]
      end

      should "set :show_as_html key to false as the default" do
        formatter = Formatter.new('filename.pdf', 'title')
        assert !formatter.render_options[:show_as_html]
      end
    end

    context 'when footers are enabled' do
      setup do
        enable_footers
      end

      should 'include footer options' do
        assert ChiliPDF::Config.footer_enabled?
        assert @formatter.render_options.has_key?(:footer)
      end
    end

    context 'when footers are disabled' do
      setup do
        disable_footers
      end

      should "not include a 'footer' key" do
        assert !@formatter.render_options.has_key?(:footer)
      end
    end

    context 'when headers are enabled' do
      setup do
        enable_headers
      end

      should 'include header options' do
        assert @formatter.render_options.has_key?(:header)
      end
    end

    context 'when headers are disabled' do
      setup do
        disable_headers
      end

      should "not include a 'header' key" do
        assert !@formatter.render_options.has_key?(:header)
      end
    end

    context "replacing 'dynamic tokens' with expected content" do
      should "substitues '{{current_page}}' with '[page]'" do
        set_header_field_to "{{current_page}}"

        assert ChiliPDF::Config.footer_enabled?
        assert_equal '[page]', @formatter.render_options[:header][:left]
      end

      should "substitues '{{total_pages}}' with '[topage]'" do
        set_header_field_to "{{total_pages}}"

        assert ChiliPDF::Config.footer_enabled?
        assert_equal '[topage]', @formatter.render_options[:header][:left]
      end

      should "substitues '{{datestamp}}' with a date formated as 'DD-MON-YYYY'" do
        todays_date = Time.now.strftime('%d-%b-%Y')

        set_header_field_to "{{datestamp}}"
        assert_equal todays_date, header_value
      end

      context "when a page title is supplied" do
        setup do
          @custom_title = 'Custom title'
          @formatter = ChiliPDF::Formatter.new('filename.pdf', @custom_title)
        end

        should "substitute '{{page_title}}' with a string value passed in as the 'page_title' argument" do
          set_header_field_to "{{page_title}}"

          assert ChiliPDF::Config.footer_enabled?
          assert_equal @custom_title, header_value
        end
      end

      context "when a page title is not supplied" do
        should "substitues '{{page_title}}' with the default page title value '#{ChiliPDF::Formatter::DEFAULT_PAGE_TITLE}'" do
          set_header_field_to "{{page_title}}"
          assert_equal ChiliPDF::Formatter::DEFAULT_PAGE_TITLE, header_value
        end
      end

      # The next couple are slightly hacky (or...maybe super-hacky)
      should "substitues '{{current_year}}' with the current year (formated as 'YYYY')" do
        todays_date = Time.now.strftime('%Y')

        set_header_field_to "{{current_year}}"
        assert_equal todays_date, header_value
      end

      should "substitues '{{current_quarter}}' with a string value of 1, 2, 3, 4...depending on month of year" do
        month = Time.now.strftime('%m').to_i
        expected = (((month - 1) / 3) + 1).to_s

        set_header_field_to '{{current_quarter}}'
        assert_equal expected, header_value
      end
    end
  end
end
