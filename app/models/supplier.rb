class Supplier < ApplicationRecord
  belongs_to :manager, class_name: "User", foreign_key: "manager_id"

  has_many :material_assets, dependent: :destroy
  has_many_attached :uploads, dependent: :purge_later

  validates :name, :bin, presence: true, uniqueness: { case_sensitive: false }
  validates_length_of :bin, { is: 12 }
  validates_format_of :email_address, with: URI::MailTo::EMAIL_REGEXP, allow_blank: true
  validates_format_of :phone_number, with: /\A\+[0-9]+[0-9]{3}[0-9]{7}\z/, allow_blank: true
end
