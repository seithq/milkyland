module Locatable
  extend ActiveSupport::Concern

  included do
    has_many :all_locations, -> { Location.recent_first }, as: :storable, class_name: "Location", dependent: :destroy
    has_many :all_elements, -> { Location.recent_first }, as: :positionable, class_name: "Location", dependent: :destroy

    has_many :locations, -> { Location.active.recent_first }, as: :storable, dependent: :destroy
    has_many :elements, -> { Location.active.recent_first }, as: :positionable, class_name: "Location", dependent: :destroy

    def locate_to(position)
      transaction do
        location = Location.create!(storable: self, positionable: position)
        locations.where.not(id: location.id).each { |location| location.deactivate }
      end
    end
  end
end
