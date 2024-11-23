class GenerationDownload < ApplicationRecord
  belongs_to :generation

  enum :kind, %w[ boxes pallets ].index_by(&:itself)
  enum :status, %w[ processing completed failed ].index_by(&:itself), default: :processing

  has_one_attached :archive, dependent: :purge_later

  broadcasts_refreshes_to :generation

  scope :boxes, -> { where(kind: :boxes) }
  scope :pallets, -> { where(kind: :pallets) }
end
