class TagMangler
  def initialize(src, request_like_object = nil)
    @src_attribute = src # /roy
    @request_like = request_like_object
  end

  def to_local_src
    full_file_path.blank? ? @src_attribute : "file://#{full_file_path}"
  end

  def to_absolute_url
    relative_url? ? "#{base_url}#{relative_url}" : @src_attribute
  end

  private
    def base_url
      @request_like.url.sub(@request_like.request_uri, '/')
    end

    def full_file_path
      if requesting_valid_static_asset?
        requested_path
      elsif requesting_attachment? && !attachment.blank?
        attachment.diskfile
      end
    end

    def relative_url
      @src_attribute.match(%r!^/(.*)!) && $1
    end

    def relative_url?
      !relative_url.blank?
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
      File.expand_path(File.join(public_path, @src_attribute))
    end

    def public_path
      File.expand_path(File.join(Rails.root, 'public'))
    end

    def requested_asset_under_public_dir?
      requested_path.match(/^#{public_path}/)
    end

    # Pull the specified attachment ID out of the @src_attribute
    # if it is in one of the 'standad' URL formats
    # (ie: the :id field from the examples below)
    #
    # Example URLs:
    #   /attachments/:id/:filename
    #   /attachments/download/:id
    #
    # Returns the specified id as a string if a valid one is present
    # Returns nil otherwise
    def attachment_id
      regexp = Regexp.new(/\/?attachments(?:\/download)?\/(\d+)\/?.*/)
      @src_attribute.match(regexp) && $1
    end


end


