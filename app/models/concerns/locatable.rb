module Locatable
  extend ActiveSupport::Concern

  included do
    has_many :all_locations, as: :storable, class_name: "Location", dependent: :destroy
    has_many :all_elements, as: :positionable, class_name: "Location", dependent: :destroy

    has_many :locations, -> { active }, as: :storable, dependent: :destroy
    has_many :elements, -> { active }, as: :positionable, class_name: "Location", dependent: :destroy

    def locate_to(position)
      transaction do
        locations.update_all(active: false)
        Location.create!(storable: self, positionable: position)
      end
    end

    def clear_locations!
      transaction do
        locations.update_all(active: false)
      end
    end

    def all_pallets
      ids = pallet_scopes.map { |scope| scope.pluck(:id) }.reduce(&:+)
      Pallet.where(id: ids)
    end

    def all_boxes
      ids = box_scopes.map { |scope| scope.pluck(:id) }.reduce(&:+)
      Box.filter_by_ids(ids).active
    end

    def capacity_by(product_id, production_date: nil, ids: [])
      base_scope = all_boxes.filter_by_product(product_id)
      base_scope = base_scope.filter_by_production_date(production_date) unless production_date.nil?
      base_scope = base_scope.filter_by_ids(ids) if ids.any?
      base_scope.sum(:capacity)
    end

    def capacity_by_dates(product_id, ids: [])
      base_scope = all_boxes.filter_by_product(product_id)
      base_scope = base_scope.filter_by_ids(ids) if ids.any?
      base_scope.group(:production_date).sum(:capacity)
    end

    def can_be_deactivated?
      all_boxes.sum(:capacity).zero?
    end

    def current_position
      locations.first&.positionable
    end

    private
      def pallet_scopes
        raise NotImplementedError.new "Implement in subclass"
      end

      def box_scopes
        raise NotImplementedError.new "Implement in subclass"
      end

      def hierarchy_classes
        raise NotImplementedError.new "Implement in subclass"
      end
  end
end
