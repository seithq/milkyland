class ChangePackingTypeOnMaterialAssets < ActiveRecord::Migration[8.0]
  def change
    reversible do |direction|
      change_table :material_assets do |t|
        direction.up   { t.change :packing, :decimal, precision: 20, scale: 2, using: "packing::decimal" }
        direction.down { t.change :packing, :string }
      end
    end
  end
end
