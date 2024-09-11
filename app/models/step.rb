class Step < ApplicationRecord
  include Progressable

  belongs_to :batch
  belongs_to :operation

  validates_uniqueness_of :operation_id, scope: :batch_id
end
