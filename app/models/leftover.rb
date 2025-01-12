class Leftover < ApplicationRecord
  belongs_to :waybill
  belongs_to :storage

  belongs_to :subject, polymorphic: true

  belongs_to :parent, class_name: "Leftover", foreign_key: "parent_id", optional: true
  has_one :child, class_name: "Leftover", foreign_key: "parent_id", dependent: :destroy

  before_validation :set_storage, on: :create, unless: ->() { storage.present? }
  before_validation :keep_negative, on: :update

  after_create  :create_child_leftover, unless: ->() { parent.present? }
  after_update  :update_child_leftover
  after_destroy :destroy_child_leftover

  scope :positive, ->() { where("count > 0") }
  scope :negative, ->() { where("count < 0") }

  scope :filter_by_subject, ->(subject) { where(subject: subject) }
  scope :filter_by_storage, ->(storage_id) { where(storage_id: storage_id) }

  scope :report_for_products, ->() do
    joins(:waybill)
      .joins("JOIN products ON leftovers.subject_id = products.id AND leftovers.subject_type = 'Product'")
      .joins("JOIN groups ON products.group_id = groups.id")
      .where(waybills: { status: :approved })
      .select(
        "groups.id AS group_id",
        "groups.name AS group_name",
        "products.id AS product_id",
        "products.name AS product_name",
        "SUM(leftovers.count) AS total_count"
      )
      .group("groups.id, groups.name, products.id, products.name")
      .order("groups.name, products.name")
  end

  scope :report_for_material_assets, ->() do
    joins(:waybill)
      .joins("JOIN material_assets ON leftovers.subject_id = material_assets.id AND leftovers.subject_type = 'MaterialAsset'")
      .joins("JOIN categories ON material_assets.category_id = categories.id")
      .select(
        "categories.id AS category_id",
        "categories.name AS category_name",
        "material_assets.id AS material_asset_id",
        "material_assets.name AS material_asset_name",
        "SUM(leftovers.count) AS total_count"
      )
      .group("categories.id, categories.name, material_assets.id, material_assets.name")
      .order("categories.name, material_assets.name")
  end

  private
    def set_storage
      self.storage = %w[ arrival transfer return_back ].include?(waybill.kind) ? waybill.new_storage : waybill.storage
      self.count   *= -1.0 if %w[ departure write_off production_write_off ].include?(waybill.kind)
    end

    def create_child_leftover
      return unless %w[ transfer ].include?(waybill.kind)

      waybill.leftovers.create!(parent_id: self.id,
                                storage_id: waybill.storage_id,
                                subject_type: self.subject_type,
                                subject_id: self.subject_id,
                                count: self.count * -1.0)
    end

    def update_child_leftover
      Leftover.find_by(parent_id: self.id)&.update count: self.count * -1.0
    end

    def destroy_child_leftover
      Leftover.find_by(parent_id: self.id)&.destroy
    end

    def keep_negative
      self.count *= -1.0 if self.count_was.negative? && self.count.positive?
    end
end
