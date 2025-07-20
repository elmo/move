class AttachmentsController < ApplicationController
  def show
     blob = ActiveStorage::Blob.find_by(key: params[:id])
     content_type = blob.content_type
     image_data = blob.download
     send_data(image_data, filename: blob.key, content_type: content_type, disposition: "inline")
  end

  def purge
    begin
      blob = ActiveStorage::Blob.find_by(key: params[:id])
      attachment = ActiveStorage::Attachment.find_by(blob_id: blob.id)
      attachable = attachment.record_type.constantize.find(attachment.record.id)

      if attachable.is_a?(Provider)
        return_path = edit_provider_path(attachable)
      else
        return_path = edit_rfp_path(attachable)
      end

      blob.attachments.each do |attachment|
        attachment.purge
      end
    rescue
      redirect_back fallback_location: return_path, alert: "Could not delete image. Please contact support." and return false
    end
    redirect_back fallback_location: return_path, notice: "Image successfully remove from uploaded files" and return false
  end
end

