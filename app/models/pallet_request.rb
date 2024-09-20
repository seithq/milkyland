class PalletRequest < ApplicationRecord
  belongs_to :generation

  has_many :pallets, dependent: :nullify

  validates :count, presence: true, numericality: { only_integer: true }

  after_create_commit :generate_pallets_with_qr

  private
    def generate_pallets_with_qr
      PalletGenerationJob.perform_later(self.id)
    end
end
