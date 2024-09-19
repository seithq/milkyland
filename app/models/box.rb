class Box < ApplicationRecord
  belongs_to :region
  belongs_to :product
  belongs_to :box_request, optional: true

  has_one_attached :qr_image, dependent: :purge_later

  before_validation :assign_code, on: :create

  validates_uniqueness_of :code
  validates_presence_of :production_date, :expiration_date
  validates :capacity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  broadcasts_refreshes_to ->(box) { box.box_request.generation }

  def scan!(time: Time.zone.now)
    update! scanned_at: time
  end

  private
    def assign_code
      self.code = loop do
        new_code = generate_code
        break new_code unless Box.find_by(code: new_code)
      end
    end

    def generate_code
      parts = [
        "BOX",
        region.code,
        product.article,
        capacity,
        production_date.strftime("%Y%m%d"),
        expiration_date.strftime("%Y%m%d"),
        SecureRandom.hex(8)
      ]
      parts.join("-").upcase
    end
end
