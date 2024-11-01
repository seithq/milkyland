class Location < ApplicationRecord
  belongs_to :storable, polymorphic: true
  belongs_to :position, polymorphic: true
end
