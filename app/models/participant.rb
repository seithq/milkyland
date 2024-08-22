class Participant < ApplicationRecord
  include Deactivatable

  belongs_to :promotion
  belongs_to :client

  validates_uniqueness_of :client_id, scope: :promotion_id
end
