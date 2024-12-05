class User < ApplicationRecord
  include Role, Transferable

  has_many :sessions, dependent: :destroy
  has_many :suppliers, foreign_key: "manager_id", dependent: :destroy
  has_many :clients, foreign_key: "manager_id", dependent: :destroy
  has_secure_password validations: false

  has_many :out_waybills, class_name: "Waybill", foreign_key: "sender_id",   dependent: :nullify
  has_many :in_waybills,  class_name: "Waybill", foreign_key: "receiver_id", dependent: :nullify

  has_many :warehousers, dependent: :destroy
  has_many :storages, through: :warehousers
  has_many :zones, through: :storages

  has_many :assemblies, dependent: :destroy

  before_validation :set_random_credentials, if: :restricted?

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates_presence_of :email_address, unless: :restricted?
  validates_uniqueness_of :email_address, case_sensitive: false, allow_blank: true

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(:name) }

  scope :filter_by_name_or_email, ->(query) { where("LOWER(name) LIKE ? OR LOWER(email_address) LIKE ?", like(query), like(query)) }

  def current?
    self == Current.user
  end

  def deactivate
    transaction do
      sessions.delete_all
      update! active: false, email_address: deactived_email_address
    end
  end

  private
    def deactived_email_address
      email_address&.gsub(/@/, "-deactivated-#{SecureRandom.uuid}@")
    end

    def set_random_credentials
      self.email_address = "#{SecureRandom.uuid}@milkyland.kz"
      self.password = SecureRandom.hex(10)
    end
end
