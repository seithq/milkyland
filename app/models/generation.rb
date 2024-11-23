class Generation < ApplicationRecord
  belongs_to :distributed_product

  has_many :box_requests, dependent: :destroy
  accepts_nested_attributes_for :box_requests
  has_many :boxes, through: :box_requests

  has_many :pallet_requests, dependent: :destroy
  accepts_nested_attributes_for :pallet_requests
  has_many :pallets, through: :pallet_requests

  has_one :boxes_download, -> { boxes }, class_name: "GenerationDownload", foreign_key: "generation_id", dependent: :destroy
  has_one :pallets_download, -> { pallets }, class_name: "GenerationDownload", foreign_key: "generation_id", dependent: :destroy

  enum :status, %w[ in_planning processing completed ].index_by(&:itself), default: :in_planning

  after_create_commit :generate_boxes_with_qr

  def finished?
    finished_at?
  end

  def start!
    update! status: :processing, finished_at: nil
  end

  def finish!(time: Time.zone.now)
    update! status: :completed, finished_at: time
  end

  def reset!
    update! status: :in_planning, finished_at: nil
  end

  def total_boxes
    box_requests.sum(:count)
  end

  def generated_boxes
    boxes.count
  end

  def box_progress
    (generated_boxes.to_d / total_boxes.to_d) * 100.0
  end

  def box_progress_completed?
    generated_boxes == total_boxes
  end

  def boxes_download_completed?
  end

  def total_pieces
    distributed_product.count
  end

  def generated_pieces
    boxes.sum(:capacity)
  end

  def pieces_progress
    (generated_pieces.to_d / total_pieces.to_d) * 100.0
  end

  def zip_name(prefix = "boxes")
    [ prefix,
      distributed_product.region.code,
      distributed_product.packaged_product.product.article,
      distributed_product.count,
      SecureRandom.hex(6)
    ].join("-").upcase + ".zip"
  end

  private
    def generate_boxes_with_qr
      BoxGenerationJob.perform_later(self.id)
    end
end
