class MaterialAsset < ApplicationRecord
  belongs_to :category
  belongs_to :measurement

  has_many :ingredients, dependent: :destroy
  has_many :containers, dependent: :destroy

  has_many :box_packagings, dependent: :destroy
  has_many :single_packagings, dependent: :destroy

  has_many :supply_orders, dependent: :destroy

  has_many :leftovers, as: :subject, dependent: :destroy
  has_many :storages, through: :leftovers

  has_many :transactions, dependent: :nullify

  has_many :vendors, dependent: :destroy

  validates :article, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  scope :combined_assets, ->() { joins(:category).merge(Category.combined_assets) }
  scope :raw_products, ->() { joins(:category).merge(Category.raw_products) }
  scope :packings, ->() { joins(:category).merge(Category.packings) }
  scope :group_packings, ->() { joins(:category).merge(Category.group_packings) }

  scope :ordered, -> { order(article: :asc) }

  scope :filter_by_name, ->(name) { where("LOWER(material_assets.name) LIKE ?", like(name)) }

  def display_label(storage = nil)
    if storage.nil?
      "#{ name } (#{ measurement.unit })"
    else
      "#{ name } (#{ storage.available_count(self) } #{ measurement.unit })"
    end
  end

  def available_count(storage_id = nil)
    base_scope = leftovers
    base_scope = base_scope.filter_by_storage(storage_id) unless storage_id.nil?
    base_scope.sum(:count)
  end
end
