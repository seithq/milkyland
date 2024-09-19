class RemoveMaterialAssetFromProducts < ActiveRecord::Migration[8.0]
  def change
    remove_column :products, :material_asset_id
  end
end
