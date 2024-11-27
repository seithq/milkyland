class ChangePackingPrecision < ActiveRecord::Migration[8.1]
  def change
    change_column :products, :packing, :decimal, precision: 10, scale: 3
    change_column :material_assets, :packing, :decimal, precision: 10, scale: 3
  end
end
