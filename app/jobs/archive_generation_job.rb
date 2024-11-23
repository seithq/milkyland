require "zip"

class ArchiveGenerationJob < ApplicationJob
  queue_as :default

  rescue_from(ActiveRecord::RecordNotFound) do |exception|
    Rails.logger.error("ArchiveGenerationJob: #{exception.message}")
  end

  def perform(generation_download_id, zip_name, model_type, model_ids)
    generation_download = GenerationDownload.find(generation_download_id)
    return unless generation_download.processing?

    zip_scope = model_type.constantize.where(id: model_ids)
    string_io = Zip::OutputStream.write_buffer do |zip_io|
      zip_scope.each do |record|
        zip_io.put_next_entry record.qr_image.filename
        zip_io.write record.qr_image.blob.download
      end
    end
    string_io.rewind

    generation_download.transaction do
      generation_download.archive.attach(io: string_io, filename: zip_name)
      generation_download.update! status: :completed
    rescue Exception => exception
      Rails.logger.error("ArchiveGenerationJob: #{exception.message}")
      generation_download.update! status: :failed
    end

    generation_download.completed?
  end
end
