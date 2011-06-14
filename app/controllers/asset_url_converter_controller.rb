class AssetURLConverterController < ApplicationController
  unloadable

  # /asset_url_converter?asset=attachments/1
  def convert
    if full_file_path.blank?
      head :not_found
    else
      render :text => full_file_path
    end
  end

  private
    def full_file_path
      if requesting_valid_static_asset?
        "file://#{requested_path}"
      elsif requesting_attachment? && !attachment.blank?
        attachment.diskfile
      end
    end

    def attachment
      Attachment.find_by_id(attachment_id)
    end

    def requesting_attachment?
      !attachment_id.blank?
    end

    def requesting_valid_static_asset?
      requested_asset_under_public_dir? && static_asset_exists?
    end

    def static_asset_exists?
      File.exists?(requested_path)
    end

    def requested_path
      File.expand_path(File.join(public_path, params[:asset_url]))
    end

    def public_path
      File.expand_path(File.join(Rails.root, 'public'))
    end

    def requested_asset_under_public_dir?
      requested_path.match(/^#{public_path}/)
    end

    # Pull the specified attachment ID out of the :asset_url
    # URL parameter if it is in one of the 'standad' URL formats
    # (ie: the :id field from the examples below)
    #
    # Example URLs:
    #   /attachments/:id/:filename
    #   /attachments/download/:id
    #
    # Returns the specified id as a string if a valid one is present
    # Returns nil otherwise
    def attachment_id
      regexp = Regexp.new(/attachments(?:\/download)?\/(\d+)\/?.*/)
      params[:asset_url].match(regexp) && $1
    end

end
