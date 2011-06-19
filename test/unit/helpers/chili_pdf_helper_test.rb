require File.dirname(__FILE__) + '/../../test_helper'

class ChiliPdfHelperTest < HelperTestCase
  include ChiliPdfHelper

  context "#chili_pdf_stylesheets" do
    should "include the pdf.css stylesheet" do
      assert_match %r(<link.*href=['"].*pdf\.css['"].*>), chili_pdf_stylesheets(false)
    end

    context "when making an HTML request" do
      should "set the vale of the 'href' attribute to a relative URL" do
        assert_match %r(<link.*href=['"]/.*\.css['"].*>), chili_pdf_stylesheets(true)
      end
    end

    context "when making a PDF request" do
      should "set the vale of the 'href' attribute to a file://-based location" do
        assert_match %r(<link.*href=['"]file://.*\.css['"].*>), chili_pdf_stylesheets(false)
      end
    end
  end

  context "#chili_pdf_javascripts" do
    should "include the prototype JavaScript library" do
      assert_match %r(<script.*src=['"].*prototype\.js['"].*></script>), chili_pdf_javascripts(false)
    end

    context "when making an HTML request" do
      should "set the vale of the 'src' attribute to a relative URL" do
        assert_match %r(<script.*src=['"]/.*\.js['"].*></script>), chili_pdf_javascripts(true)
      end
    end

    context "when making a PDF request" do
      should "set the vale of the 'src' attribute to a file://-based location" do
        assert_match %r(<script.*src=['"]file://.*\.js['"].*></script>), chili_pdf_javascripts(false)
      end
    end
  end

  context "#normalize_custom_link_href_tags_in" do
    setup do
      @html = "<link href='/stylesheets/application.css' />"
    end

    context "when making an HTML request" do
      should "set the vale of the 'href' attribute to a relative URL" do
        results = normalize_custom_link_href_tags_in(@html, true)
        assert_match %r(<link.*href=['"]/stylesheets/application\.css['"].*>), results
      end
    end

    context "when making a PDF request" do
      should "set the vale of the 'href' attribute to a file://-based location" do
        results = normalize_custom_link_href_tags_in(@html, false)
        assert_match %r(<link.*href=['"]file://.*/stylesheets/application\.css['"].*>), results
      end
    end
  end

  context "#normalize_custom_js_src_tags_in" do
    setup do
      @html = "<script src='/plugin_assets/chili_pdf/javascripts/chili_pdf.js'></script>"
    end

    context "when making an HTML request" do
      should "set the vale of the 'src' attribute to a relative URL" do
        results = normalize_custom_js_src_tags_in(@html, true)
        assert_match %r(<script.*src=['"]/plugin_assets/chili_pdf/javascripts/chili_pdf\.js['"].*></script>), results
      end
    end

    context "when making a PDF request" do
      should "set the vale of the 'src' attribute to a file://-based location" do
        results = normalize_custom_js_src_tags_in(@html, false)
        assert_match %r(<script.*src=['"]file://.*/plugin_assets/chili_pdf/javascripts/chili_pdf\.js['"].*></script>), results
      end
    end
  end

  context "#update_img_src_tags_of" do
    setup do
      @html = "<img src='/images/cancel.png'>"
    end

    context "when making an HTML request" do
      should "set the vale of the 'src' attribute to a relative URL" do
        results = update_img_src_tags_of(@html, true)
        assert_match %r(<img.*src=['"]/images/cancel\.png['"].*>), results
      end
    end

    context "when making a PDF request" do
      should "set the vale of the 'src' attribute to a file://-based location" do
        results = update_img_src_tags_of(@html, false)
        assert_match %r(<img.*src=['"]file://.*/images/cancel\.png['"].*>), results
      end
    end
  end

  context "#logo_img_tag" do
    context "when no logo URL is defined for the plugin" do
      setup do
        ChiliPDF::Config.stubs(:logo_url).returns("")
      end

      should "return nil" do
        assert_nil logo_img_tag(true)
      end
    end

    context "when a logo URL is defined" do
      setup do
        ChiliPDF::Config.stubs(:logo_url).returns("/images/cancel.png")
      end

      should "return an '<img>' tag with an 'id' of 'chili-pdf-logo'" do
        assert_match /id="chili-pdf-logo"/, logo_img_tag(true)
      end
    end
  end
end
