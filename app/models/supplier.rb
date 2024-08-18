class Supplier < ApplicationRecord
  include Entitable

  has_many :material_assets, dependent: :destroy
end
