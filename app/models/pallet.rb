class Pallet < ApplicationRecord
  include Codable

  belongs_to :pallet_request, optional: true

  has_one_attached :qr_image, dependent: :purge_later

  before_validation :assign_code, on: :create

  validates_uniqueness_of :code

  broadcasts_refreshes_to ->(pallet) { pallet.pallet_request.generation }

  def scan!(time: Time.zone.now)
    update! scanned_at: time
  end

  private
    def assign_code
      self.code = loop do
        new_code = generate_code
        break new_code unless Pallet.find_by(code: new_code)
      end
    end

    def generate_code
      parts = [ "PLT", SecureRandom.hex(16) ]
      parts.join("-").upcase
    end
end
