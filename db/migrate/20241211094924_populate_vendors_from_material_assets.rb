class PopulateVendorsFromMaterialAssets < ActiveRecord::Migration[8.1]
  def up
    MaterialAsset.all.each do |material_asset|
      material_asset.vendors.create supplier_id: material_asset.supplier_id,
                                    entry_price: material_asset.entry_price,
                                    delivery_time_in_days: material_asset.delivery_time_in_days
    end
  end

  def down
  end
end
