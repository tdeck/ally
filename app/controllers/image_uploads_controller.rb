class ImageUploadsController < ApplicationController
  # Let the public view images (main use case is newsletter)
  skip_before_action :require_session!, only: [:show]

  def new
  end

  def create
    image = params.require(:image)
    image_bytes = image.read
    sha1 = Digest::SHA1.hexdigest(image_bytes)

    # If we already have the image, don't create another record
    # Note: There's an unlikely race here
    @record = ImageUpload.find_by_sha1(sha1)

    unless @record
      @record = ImageUpload.create!(
        title: params.require(:title),
        mime_type: image.content_type,
        bytes: image_bytes,
        sha1: sha1,
        creator_uid: session['uid']
      )
    end

    respond_to do |format|
      format.html # Render view
      format.json do
        render json: {url: url_for(@record)}
      end
    end
  end

  def show
    record = ImageUpload.find_by_sha1!(params[:id])
    send_data record.bytes, type: record.mime_type, disposition: :inline
  end

end
