class RemoveMaterialAssetReferenceInProducts < ActiveRecord::Migration[8.1]
  def change
    remove_column :products, :material_asset_id
  end
end
