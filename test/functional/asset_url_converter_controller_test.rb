require File.dirname(__FILE__) + '/../test_helper'

class AssetURLConverterControllerTest < ActionController::TestCase
  context "GET to #convert" do
    context "when requesting a static asset" do
      should "does not allow relative URLs which resolve to anything 'above' public on the filesystem" do
        get :convert, :asset_url => "../Rakefile"
        assert_response :not_found
      end

      context "which does not exist on the filesystem" do
        setup do
          @asset_url = 'stylesheets/faux_css_file_fildjakfldsa.css'
        end

        should "returns a 404 response code" do
          get :convert, :asset_url => @asset_url
          assert_response :not_found
        end
      end

      context "which does exist on the filesystem" do
        setup do
          # slightly brittle, but assuming application.css
          # will always ship w/ app...
          @asset_url = 'stylesheets/application.css'
        end

        should "return a 200 response code" do
          get :convert, :asset_url => @asset_url
          assert_response :success
        end

        should "render the full (local) path to the file" do
          css_path = File.join(Rails.root, 'public', 'stylesheets', 'application.css')
          get :convert, :asset_url => @asset_url

          assert_equal css_path, @response.body
        end
      end
    end

    context "when requesting an Attachment" do
      setup do
        @asset_url = '/attachments/download/1'
      end

      context "using a URI in the form of 'attachments/download/1'"do
        setup do
          @asset_url = '/attachments/download/200'
        end

        should "search for an attachment with an id of '200'" do
          Attachment.expects(:find).with(:first, {:conditions => {:id => '200'}})
          get :convert, :asset_url => @asset_url
        end
      end

      context "using a URI in the form of 'attachments/2/after.png'"do
        setup do
          @asset_url = 'attachments/2/after.png'
        end

        should "search for an attachment with an id of '2'" do
          Attachment.expects(:find).with(:first, :conditions => {:id => '2'})
          get :convert, :asset_url => @asset_url
        end
      end

      context "which does not exist" do
        setup do
          @controller.stubs(:attachment).returns(nil)
        end

        should "returns a 404 response code" do
          get :convert, :asset_url => @asset_url
          assert_response :not_found
        end
      end

      context "which exists" do
        setup do
          @local_path = '/a/local/path/to/file.png'
          @req_file = mock_file
          @req_file.stubs(:diskfile).returns(@local_path)

          @controller.stubs(:attachment).returns(@req_file)
        end

        should "return a 200 response code" do
          get :convert, :asset_url => @asset_url
          assert_response :success
        end

        should "render the full (local) path to the file" do
          get :convert, :asset_url => @asset_url
          assert_equal @local_path, @response.body
        end
      end
    end

    context "requesting an attachment using a URI in the form of 'attachments/:id/:filename'" do
    end
  end
end
