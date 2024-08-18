class Client < ApplicationRecord
  include Entitable

  has_many :sales_points, dependent: :destroy
end
