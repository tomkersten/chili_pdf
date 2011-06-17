require File.dirname(__FILE__) + '/../test_helper'

def make_mangler_with(asset_path)
  TagMangler.new(asset_path)
end

# Stolen from the Rails.root test_helper...
# not sure why they are not being included in here yet
def mock_file
  file = 'a_file.png'
  file.stubs(:size).returns(32)
  file.stubs(:original_filename).returns('a_file.png')
  file.stubs(:content_type).returns('image/png')
  file.stubs(:read).returns(false)
  file
end

class TokenManagerTest < Test::Unit::TestCase
  context "#to_local_src" do
    context "when requesting a static asset" do
      setup do
        @requested_asset = "../Rakefile"
        @mangler = make_mangler_with(@requested_asset)
      end

      context "which is not nested under the 'public' directory of the application" do
        should "return the original value without any modifications" do
          assert_equal @requested_asset, @mangler.to_local_src
        end
      end

      context "which does not exist on the filesystem" do
        setup do
          @requested_asset = 'stylesheets/faux_css_file_fildjakfldsa.css'
          @mangler = make_mangler_with(@requested_asset)
        end

        should "return the original value without any modifications" do
          assert_equal @requested_asset, @mangler.to_local_src
        end
      end

      context "which does exist on the filesystem" do
        setup do
          # slightly brittle, but assuming application.css
          # will always ship w/ app...
          @requested_asset = 'stylesheets/application.css'
          @mangler = make_mangler_with(@requested_asset)
        end

        should "return the full (local) path to the file prepended with 'file://'" do
          css_path = File.join(Rails.root, 'public', 'stylesheets', 'application.css')
          assert_equal "file://#{css_path}", @mangler.to_local_src
        end
      end
    end

    context "when requesting an Attachment" do
      context "using a URI in the form of 'attachments/download/200'"do
        setup do
          @requested_asset = '/attachments/download/200'
          @mangler = make_mangler_with(@requested_asset)
        end

        should "search for an attachment with an id of '200'" do
          Attachment.expects(:find).with(:first, {:conditions => {:id => '200'}})
          @mangler.to_local_src
        end
      end

      context "using a URI in the form of 'attachments/2/after.png'"do
        setup do
          @requested_asset = 'attachments/2/after.png'
          @mangler = make_mangler_with(@requested_asset)
        end

        should "search for an attachment with an id of '2'" do
          Attachment.expects(:find).with(:first, :conditions => {:id => '2'})
          @mangler.to_local_src
        end
      end

      context "which does not exist" do
        setup do
          @requested_asset = '/attachments/download/1'
          @mangler = make_mangler_with(@requested_asset)
          Attachment.expects(:find).returns(nil)
        end

        should "return the original value without any modifications" do
          assert_equal @requested_asset, @mangler.to_local_src
        end
      end

      context "which exists" do
        setup do
          # Set up faux local file location & Attachment instance
          @local_path = '/a/local/path/to/file.png'
          @req_attachment = mock_file
          @req_attachment.stubs(:diskfile).returns(@local_path)

          # Stub finding the instance
          Attachment.stubs(:find).returns(@req_attachment)

          @requested_asset = '/attachments/download/200'
          @mangler = make_mangler_with(@requested_asset)
        end

        should "render the full (local) path to the file" do
          assert_equal "file://#{@local_path}", @mangler.to_local_src
        end
      end
    end
  end
end
