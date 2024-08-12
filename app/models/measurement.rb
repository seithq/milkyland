class Measurement < ApplicationRecord
  validates_presence_of :name, :unit
  validates_uniqueness_of :unit

  def display_label
    "#{ name } (#{ unit })"
  end
end
