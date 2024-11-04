module Locatable
  extend ActiveSupport::Concern

  included do
    has_many :all_locations, as: :storable, class_name: "Location", dependent: :destroy
    has_many :all_elements, as: :positionable, class_name: "Location", dependent: :destroy

    has_many :locations, -> { Location.active }, as: :storable, dependent: :destroy
    has_many :elements, -> { Location.active }, as: :positionable, class_name: "Location", dependent: :destroy

    def locate_to(position)
      transaction do
        locations.update_all(active: false)
        Location.create!(storable: self, positionable: position)
      end
    end
  end
end
