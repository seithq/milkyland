class Position < ApplicationRecord
  belongs_to :order
  belongs_to :product
  belongs_to :promotion, optional: true

  before_validation :set_total_sum

  validates :count, presence: true, numericality: { only_integer: true }
  validates :base_price, :discounted_price, :total_sum, presence: true, numericality: { greater_than: 0.0 }

  validates_numericality_of :discounted_price, less_than_or_equal_to: :base_price
  validates_numericality_of :total_sum, equal_to: ->(pos) { pos.default_value(:count, 0) * pos.default_value(:discounted_price, 0.0) }

  scope :filter_by_group, ->(group_id) { joins(product: :group).merge(Product.filter_by_group(group_id)) }
  scope :filter_by_product, ->(product_id) { joins(:product).where(products: { id: product_id }) }

  def default_value(field, default)
    self.send(field).presence || default
  end

  private
    def set_total_sum
      trigger = if new_record?
        total_sum.blank?
      else
        product_id_changed? || count_changed?
      end

      self.total_sum = default_value(:discounted_price, 0.0) * default_value(:count, 0) if trigger
    end
end
