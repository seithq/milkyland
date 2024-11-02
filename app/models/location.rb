class Location < ApplicationRecord
  include Deactivatable

  belongs_to :storable, polymorphic: true
  belongs_to :positionable, polymorphic: true
end
