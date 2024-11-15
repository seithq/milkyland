class Location < ApplicationRecord
  include Deactivatable

  belongs_to :storable, polymorphic: true
  belongs_to :positionable, polymorphic: true

  validate :type_integrity, :hierarchy_level

  private
    def type_integrity
      errors.add(:storable_id, :inclusion) if storable_type == positionable_type
    end

    def hierarchy_level
      errors.add(:positionable_id, :inclusion) unless storable.send(:hierarchy_classes).include?(positionable_type)
    end
end
