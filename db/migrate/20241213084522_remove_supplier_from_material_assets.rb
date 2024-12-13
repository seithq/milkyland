class RemoveSupplierFromMaterialAssets < ActiveRecord::Migration[8.1]
  def change
    remove_reference :material_assets, :supplier
    remove_column :material_assets, :entry_price, :decimal, precision: 20, scale: 2
    remove_column :material_assets, :delivery_time_in_days, :integer
  end
end
