class MaterialAsset < ApplicationRecord
  belongs_to :category
  belongs_to :supplier
  belongs_to :measurement

  has_many :ingredients, dependent: :destroy
  has_many :containers, dependent: :destroy

  has_many :products, dependent: :destroy
  has_many :box_packagings, dependent: :destroy

  has_many :supply_orders, dependent: :destroy

  has_many :leftovers, as: :subject, dependent: :destroy
  has_many :storages, through: :leftovers

  validates :article, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true, uniqueness: { scope: :supplier, case_sensitive: false }

  scope :combined_assets, ->() { joins(:category).merge(Category.combined_assets) }
  scope :raw_products, ->() { joins(:category).merge(Category.raw_products) }
  scope :packings, ->() { joins(:category).merge(Category.packings) }

  scope :ordered, -> { order(article: :asc) }

  scope :filter_by_name, ->(name) { where("LOWER(material_assets.name) LIKE ?", like(name)) }
  scope :filter_by_supplier, ->(supplier_id) { where(supplier_id: supplier_id) }

  def display_label
    "#{ name } (#{ measurement.unit })"
  end

  def available_count
    leftovers.sum(:count)
  end
end
