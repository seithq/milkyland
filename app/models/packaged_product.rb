class PackagedProduct < ApplicationRecord
  belongs_to :packing
  belongs_to :product

  has_many :distributed_products, dependent: :destroy
  has_many :machineries, dependent: :destroy

  validates_uniqueness_of :product_id, scope: :packing_id
  validates :count, presence: true, numericality: { only_integer: true }
  validate :machineries_integrity, on: :update

  scope :filter_by_group, ->(group_id) { joins(product: :group).merge(Product.filter_by_group(group_id)) }
  scope :filter_by_product, ->(product_id) { where(product_id: product_id) }

  scope :approved, -> { joins(:packing).merge(Packing.filter_by_status(:completed)) }

  scope :without_current_batch, ->(batch_id) { joins(:packing).where.not(packings: { batch_id: batch_id }) }

  def product_packing_machines
    containers = Container.where(material_asset_id: product_packing_material_assets)
    PackingMachine.where(id: containers.pluck(:packing_machine_id))
  end

  def product_packing_material_assets
    MaterialAsset.where(id: product.single_packagings.pluck(:material_asset_id))
  end

  private
    def machineries_integrity
      errors.add(:count, :inclusion) unless machineries.sum(:count) == count
    end
end
