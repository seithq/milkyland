class User < ApplicationRecord
  include Role, Transferable

  has_many :sessions, dependent: :destroy
  has_many :suppliers, foreign_key: "manager_id", dependent: :destroy
  has_secure_password validations: false

  validates :name, :email_address, presence: true, uniqueness: { case_sensitive: false }

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(:name) }
  scope :managers, -> { filter_by_role(:manager) }

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
end
