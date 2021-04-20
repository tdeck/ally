module ApplicationHelper
  NEAR_EXPIRY_SECONDS = 60

  def valid_session?
    if session['uid'].nil? || session['credentials'].nil?
      return false
    elsif session['credentials']['expires_at'] <= Time.now.to_i
      session.delete('credentials') # Wipe out expired credentials
      return false
    end
    true
  end

  def session_near_expiry?
    valid_session? && session['credentials']['expires_at'] <= Time.now.to_i + NEAR_EXPIRY_SECONDS
  end

  def oauth_token
    session['credentials']['token']
  end

  def meetup_client
    @meetup_client ||= MeetupClient.new(oauth_token)
  end

  def user_email
    session['email']
  end

  def embed_svg(filename, options = {})
    assets = Rails.application.assets
    file = assets.find_asset(filename).source.force_encoding("UTF-8")
    doc = Nokogiri::HTML::DocumentFragment.parse file
    svg = doc.at_css "svg"
    if options[:class].present?
      svg["class"] = options[:class]
    end
    raw doc
  end

  # Returns the appropriate logo for dev or prod
  def svg_logo
    if Rails.env.production?
      'logo.svg'
    else
      'dev-logo.svg'
    end
  end

  def favicon_16_path
    if Rails.env.production?
      '/favicon-16x16.png'
    else
      '/favicon-16x16-dev.png'
    end
  end

  def favicon_32_path
    if Rails.env.production?
      '/favicon-32x32.png'
    else
      '/favicon-32x32-dev.png'
    end
  end

  def store_image_upload(image, title: null)
    image_bytes = image.read
    sha1 = Digest::SHA1.hexdigest(image_bytes)

    # If we already have the image, don't create another record
    # Note: There's an unlikely race here
    upload = ImageUpload.find_by_sha1(sha1)
    return upload unless upload.nil?

    return ImageUpload.create!(
      title: params.permit(:title),
      mime_type: image.content_type,
      bytes: image_bytes,
      sha1: sha1,
      creator_uid: session['uid']
    )
  end
end
