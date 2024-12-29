class ReturnedProduct < ApplicationRecord
  belongs_to :return
  belongs_to :product

  has_many :boxes, dependent: :nullify

  validates :count, presence: true, numericality: { greater_than: 0 }
  validates_uniqueness_of :product_id, scope: :return_id
  validate :product_integrity

  private
    def product_integrity
      product_scope = self.return.order.positions.where(product_id: self.product_id)

      if product_scope.count.zero?
        errors.add(:product_id, :inclusion)
        return
      end

      if count > product_scope.sum(:count)
        errors.add(:product_id, :inclusion)
      end
    end
end
