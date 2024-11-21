class Warehouser < ApplicationRecord
  include Deactivatable

  belongs_to :storage
  belongs_to :user

  validates_uniqueness_of :user_id, scope: :storage_id

  def user_name
    user.name
  end
end
