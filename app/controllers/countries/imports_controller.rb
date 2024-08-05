class Countries::ImportsController < ApplicationController
  def new
  end

  def create
    file = params[:file]

    blob = ActiveStorage::Blob.create_and_upload!(
      io: file,
      filename: file.original_filename,
      content_type: file.content_type
    )
    Countries::ImportJob.perform_later(blob.signed_id)
    redirect_to countries_path, notice: "Countries are being imported..."
  end
end
